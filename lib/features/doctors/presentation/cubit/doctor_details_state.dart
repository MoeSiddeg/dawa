import '../../domain/entities/doctor_entity.dart';

sealed class DoctorDetailsState {
  const DoctorDetailsState();
}

class DoctorDetailsInitial extends DoctorDetailsState {
  const DoctorDetailsInitial();
}

class DoctorDetailsLoading extends DoctorDetailsState {
  const DoctorDetailsLoading();
}

class DoctorDetailsSuccess extends DoctorDetailsState {
  final DoctorEntity doctor;

  const DoctorDetailsSuccess(this.doctor);
}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;

  const DoctorDetailsError(this.message);
}
