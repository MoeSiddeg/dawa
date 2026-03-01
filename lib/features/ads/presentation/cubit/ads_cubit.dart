import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/ads_response.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final AdsRepository _adsRepository;
  final List<AdEntity> _cachedAds = [];
  Future<void>? _loadFuture;

  AdsCubit(this._adsRepository) : super(const AdsInitial());

  Future<void> loadAds() {
    if (_cachedAds.isNotEmpty) {
      if (state is! AdsSuccess) {
        emit(AdsSuccess(List.unmodifiable(_cachedAds)));
      }
      return Future.value();
    }

    if (_loadFuture != null) {
      return _loadFuture!;
    }

    _loadFuture = _fetchAds();
    return _loadFuture!;
  }

  List<AdEntity> getAdsForPosition(int? position) {
    if (_cachedAds.isEmpty) {
      return const [];
    }

    if (position == null) {
      return List.unmodifiable(_cachedAds);
    }

    return _cachedAds
        .where((ad) => ad.position == position)
        .toList(growable: false);
  }

  Future<void> refreshAds() {
    _cachedAds.clear();
    return loadAds();
  }

  Future<void> _fetchAds() async {
    emit(const AdsLoading());
    final result = await _adsRepository.getAds();

    result.when(
      success: (response) {
        _cachedAds
          ..clear()
          ..addAll(_mapToEntities(response));

        if (_cachedAds.isEmpty) {
          emit(const AdsEmpty());
        } else {
          emit(AdsSuccess(List.unmodifiable(_cachedAds)));
        }
      },
      failure: (error) {
        emit(AdsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _loadFuture = null;
  }

  List<AdEntity> _mapToEntities(AdsResponse response) {
    return response.data
        .map(
          (ad) => AdEntity(
            id: ad.id ?? 0,
            position: ad.position ?? 0,
            image: ad.image ?? '',
            link: ad.link ?? '',
          ),
        )
        .where((ad) => ad.image.isNotEmpty)
        .toList();
  }
}
