import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/doctors_by_category_response.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';
import 'category_doctors_state.dart';
import 'doctors_state.dart';

class CategoryDoctorsCubit extends Cubit<CategoryDoctorsState> {
  final DoctorsRepository _repository;
  List<DoctorCategoryEntity> _categories = const [];
  int _selectedCategoryId = 0;

  CategoryDoctorsCubit(this._repository)
    : super(const CategoryDoctorsInitial());

  Future<void> loadCategories({required int initialCategoryId}) async {
    emit(const CategoryDoctorsLoading());

    final categoriesResult = await _repository.getDoctorCategories();

    await categoriesResult.when(
      success: (categoriesResponse) async {
        if (categoriesResponse.data == null ||
            categoriesResponse.data!.data.isEmpty) {
          emit(const CategoryDoctorsError('لا توجد تخصصات متاحة'));
          return;
        }

        _categories = [
          const DoctorCategoryEntity(
            id: 0,
            name: 'جميع التخصصات',
            alias: 'all',
          ),
          ...categoriesResponse.data!.data.map(
            (c) => DoctorCategoryEntity(id: c.id, name: c.name, alias: c.alias),
          ),
        ];

        _selectedCategoryId = initialCategoryId;

        await _loadDoctorsForCategory(_selectedCategoryId);
      },
      failure: (error) {
        emit(CategoryDoctorsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  Future<void> selectCategory(int categoryId) async {
    if (categoryId == _selectedCategoryId) return;

    _selectedCategoryId = categoryId;
    emit(const CategoryDoctorsLoading());
    await _loadDoctorsForCategory(categoryId);
  }

  Future<void> _loadDoctorsForCategory(int categoryId) async {
    // If "All Categories" is selected (id = 0), load doctors from all categories
    if (categoryId == 0) {
      await _loadAllDoctors();
      return;
    }

    final doctorsResult = await _repository.getDoctorsByCategory(categoryId);

    doctorsResult.when(
      success: (doctorsResponse) {
        final doctors = _mapDoctorsResponse(doctorsResponse);
        emit(
          CategoryDoctorsSuccess(
            categories: _categories,
            selectedCategoryId: _selectedCategoryId,
            doctors: doctors,
          ),
        );
      },
      failure: (error) {
        emit(CategoryDoctorsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  Future<void> _loadAllDoctors() async {
    final List<DoctorEntity> allDoctors = [];

    // Skip first category ("All Categories" with id=0)
    for (final category in _categories.where((c) => c.id != 0)) {
      final doctorsResult = await _repository.getDoctorsByCategory(category.id);
      doctorsResult.when(
        success: (doctorsResponse) {
          allDoctors.addAll(_mapDoctorsResponse(doctorsResponse));
        },
        failure: (_) {},
      );
    }

    emit(
      CategoryDoctorsSuccess(
        categories: _categories,
        selectedCategoryId: _selectedCategoryId,
        doctors: allDoctors,
      ),
    );
  }

  Future<void> refresh() async {
    await _loadDoctorsForCategory(_selectedCategoryId);
  }

  List<DoctorEntity> _mapDoctorsResponse(DoctorsByCategoryResponse response) {
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
