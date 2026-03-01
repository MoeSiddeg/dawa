import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/doctors_response.dart';
import '../../data/models/doctors_by_category_response.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepository _repository;
  List<DoctorEntity> _cache = const [];
  List<DoctorCategoryWithDoctors> _categoriesCache = const [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  DoctorsCubit(this._repository) : super(const DoctorsInitial());

  Future<void> loadDoctors() async {
    if (_cache.isNotEmpty) {
      emit(
        DoctorsSuccess(
          doctors: List.unmodifiable(_cache),
          hasMore: _hasMore,
          currentPage: _currentPage,
        ),
      );
      return;
    }

    if (_isLoading) return;

    _isLoading = true;
    _currentPage = 1;
    emit(const DoctorsLoading());

    final result = await _repository.getDoctors(page: _currentPage);

    result.when(
      success: (response) {
        final mapped = _mapResponse(response);
        _cache = mapped;
        _hasMore =
            response.data?.meta?.currentPage != null &&
            response.data?.meta?.lastPage != null &&
            response.data!.meta!.currentPage! < response.data!.meta!.lastPage!;

        if (_cache.isEmpty) {
          emit(const DoctorsEmpty());
        } else {
          emit(
            DoctorsSuccess(
              doctors: List.unmodifiable(_cache),
              hasMore: _hasMore,
              currentPage: _currentPage,
            ),
          );
        }
      },
      failure: (error) {
        emit(DoctorsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _isLoading = false;
  }

  Future<void> loadDoctorsByCategories() async {
    if (_categoriesCache.isNotEmpty) {
      emit(
        DoctorsByCategorySuccess(
          categories: List.unmodifiable(_categoriesCache),
        ),
      );
      return;
    }

    if (_isLoading) return;

    _isLoading = true;
    emit(const DoctorsLoading());

    final categoriesResult = await _repository.getDoctorCategories();

    await categoriesResult.when(
      success: (categoriesResponse) async {
        if (categoriesResponse.data == null ||
            categoriesResponse.data!.data.isEmpty) {
          emit(const DoctorsEmpty());
          _isLoading = false;
          return;
        }

        final List<DoctorCategoryWithDoctors> categoriesWithDoctors = [];

        for (final category in categoriesResponse.data!.data) {
          final doctorsResult = await _repository.getDoctorsByCategory(
            category.id,
          );

          doctorsResult.when(
            success: (doctorsResponse) {
              final doctors = _mapDoctorsByCategoryResponse(doctorsResponse);
              categoriesWithDoctors.add(
                DoctorCategoryWithDoctors(
                  category: DoctorCategoryEntity(
                    id: category.id,
                    name: category.name,
                    alias: category.alias,
                  ),
                  doctors: doctors,
                ),
              );
            },
            failure: (_) {},
          );
        }

        _categoriesCache = categoriesWithDoctors;

        if (_categoriesCache.isEmpty) {
          emit(const DoctorsEmpty());
        } else {
          emit(
            DoctorsByCategorySuccess(
              categories: List.unmodifiable(_categoriesCache),
            ),
          );
        }
      },
      failure: (error) {
        emit(DoctorsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _isLoading = false;
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _currentPage++;

    final result = await _repository.getDoctors(page: _currentPage);

    result.when(
      success: (response) {
        final mapped = _mapResponse(response);
        _cache = [..._cache, ...mapped];
        _hasMore =
            response.data?.meta?.currentPage != null &&
            response.data?.meta?.lastPage != null &&
            response.data!.meta!.currentPage! < response.data!.meta!.lastPage!;

        emit(
          DoctorsSuccess(
            doctors: List.unmodifiable(_cache),
            hasMore: _hasMore,
            currentPage: _currentPage,
          ),
        );
      },
      failure: (error) {
        _currentPage--;
        emit(DoctorsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _isLoading = false;
  }

  Future<void> refresh() async {
    _cache = const [];
    _categoriesCache = const [];
    _currentPage = 1;
    _hasMore = true;
    await loadDoctorsByCategories();
  }

  List<DoctorEntity> _mapResponse(DoctorsResponse response) {
    if (response.data == null) return const [];

    return response.data!.data
        .map(
          (item) => DoctorEntity(
            id: item.id,
            name: item.name,
            alias: item.alias,
            jobTitle: item.jobTitle,
            description: item.description,
            email: item.user?.email,
            phone: item.phone,
            mobile: item.mobile,
          ),
        )
        .toList(growable: false);
  }

  List<DoctorEntity> _mapDoctorsByCategoryResponse(
    DoctorsByCategoryResponse response,
  ) {
    if (response.data?.doctors == null) return const [];

    return response.data!.doctors!.data
        .map(
          (item) => DoctorEntity(
            id: item.id,
            name: item.name,
            alias: item.alias,
            jobTitle: item.jobTitle,
            description: item.description,
            email: item.user?.email,
            phone: item.phone,
            mobile: item.mobile,
            governorateName: item.governorate?.name,
            socials:
                item.socials
                    .map(
                      (s) => SocialLinkEntity(platform: s.provider, url: s.url),
                    )
                    .toList(),
          ),
        )
        .toList(growable: false);
  }
}
