import '../../domain/entities/doctor_entity.dart';
import 'doctors_state.dart';

sealed class CategoryDoctorsState {
  const CategoryDoctorsState();
}

class CategoryDoctorsInitial extends CategoryDoctorsState {
  const CategoryDoctorsInitial();
}

class CategoryDoctorsLoading extends CategoryDoctorsState {
  const CategoryDoctorsLoading();
}

class CategoryDoctorsSuccess extends CategoryDoctorsState {
  final List<DoctorCategoryEntity> categories;
  final int selectedCategoryId;
  final List<DoctorEntity> doctors;

  const CategoryDoctorsSuccess({
    required this.categories,
    required this.selectedCategoryId,
    required this.doctors,
  });

  String? get selectedCategoryName {
    final category =
        categories.where((c) => c.id == selectedCategoryId).firstOrNull;
    return category?.name;
  }
}

class CategoryDoctorsError extends CategoryDoctorsState {
  final String message;

  const CategoryDoctorsError(this.message);
}
