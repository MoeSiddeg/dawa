import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/most_viewed_medicines_response.dart';
import '../../domain/entities/most_viewed_medicine_entity.dart';
import '../../domain/repositories/most_viewed_medicines_repository.dart';
import 'most_viewed_medicines_state.dart';

class MostViewedMedicinesCubit extends Cubit<MostViewedMedicinesState> {
  final MostViewedMedicinesRepository _repository;
  List<MostViewedMedicineEntity> _cache = const [];
  bool _isLoading = false;

  MostViewedMedicinesCubit(this._repository)
    : super(const MostViewedMedicinesInitial());

  Future<void> loadMostViewedMedicines() async {
    if (_cache.isNotEmpty) {
      emit(MostViewedMedicinesSuccess(List.unmodifiable(_cache)));
      return;
    }

    if (_isLoading) {
      return;
    }

    _isLoading = true;
    emit(const MostViewedMedicinesLoading());

    final result = await _repository.getMostViewedMedicines();

    result.when(
      success: (response) {
        final mapped = _mapResponse(response);
        _cache = mapped;
        if (_cache.isEmpty) {
          emit(const MostViewedMedicinesEmpty());
        } else {
          emit(MostViewedMedicinesSuccess(List.unmodifiable(_cache)));
        }
      },
      failure: (error) {
        emit(
          MostViewedMedicinesError(error.apiErrorModel.message ?? 'حدث خطأ ما'),
        );
      },
    );

    _isLoading = false;
  }

  Future<void> refresh() async {
    _cache = const [];
    await loadMostViewedMedicines();
  }

  List<MostViewedMedicineEntity> _mapResponse(
    MostViewedMedicinesResponse response,
  ) {
    final items = response.data?.data ?? [];
    return items
        .map(
          (item) => MostViewedMedicineEntity(
            id: item.id,
            name: item.name,
            alias: item.alias,
            registrationNo: item.registrationNo,
            tradeName: item.tradeName,
            applicant: item.applicant,
            generics: item.generics,
            price: item.price,
            image: item.image,
            isFavorited: item.isFavorited ?? false,
            dosageForm: item.dosageForm,
          ),
        )
        .toList(growable: false);
  }
}
