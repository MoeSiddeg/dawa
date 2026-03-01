import '../../domain/entities/doctor_entity.dart';

sealed class DoctorsState {
  const DoctorsState();
}

class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

class DoctorsSuccess extends DoctorsState {
  final List<DoctorEntity> doctors;
  final bool hasMore;
  final int currentPage;

  const DoctorsSuccess({
    required this.doctors,
    this.hasMore = false,
    this.currentPage = 1,
  });
}

class DoctorsByCategorySuccess extends DoctorsState {
  final List<DoctorCategoryWithDoctors> categories;

  const DoctorsByCategorySuccess({required this.categories});
}

class DoctorsEmpty extends DoctorsState {
  const DoctorsEmpty();
}

class DoctorsError extends DoctorsState {
  final String message;

  const DoctorsError(this.message);
}

class DoctorCategoryEntity {
  final int id;
  final String? name;
  final String? alias;

  const DoctorCategoryEntity({required this.id, this.name, this.alias});
}

class DoctorCategoryWithDoctors {
  final DoctorCategoryEntity category;
  final List<DoctorEntity> doctors;

  const DoctorCategoryWithDoctors({
    required this.category,
    required this.doctors,
  });
}
