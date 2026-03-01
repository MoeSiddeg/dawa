import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/doctor_details_response.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';
import 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final DoctorsRepository _repository;

  DoctorDetailsCubit(this._repository) : super(const DoctorDetailsInitial());

  Future<void> loadDoctorDetails(int id) async {
    emit(const DoctorDetailsLoading());

    final result = await _repository.getDoctorDetails(id);

    result.when(
      success: (response) {
        if (response.data != null) {
          final entity = _mapToEntity(response.data!);
          emit(DoctorDetailsSuccess(entity));
        } else {
          emit(const DoctorDetailsError('لم يتم العثور على بيانات الطبيب'));
        }
      },
      failure: (error) {
        emit(DoctorDetailsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  DoctorEntity _mapToEntity(DoctorDetailsData data) {
    return DoctorEntity(
      id: data.id,
      name: data.name,
      alias: data.alias,
      jobTitle: data.jobTitle,
      description: data.description,
      email: data.user?.email,
      phone: data.phone,
      mobile: data.mobile,
      governorateName: data.governorate?.name,
      socials: data.socials
          .map((s) => SocialLinkEntity(platform: s.platform, url: s.url))
          .toList(growable: false),
    );
  }
}
