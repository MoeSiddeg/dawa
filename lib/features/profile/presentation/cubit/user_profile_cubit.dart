import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/update_profile_request.dart';
import '../../data/models/user_profile_response.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileCubit(this._repository) : super(const UserProfileInitial());

  Future<void> loadUserProfile() async {
    emit(const UserProfileLoading());

    final result = await _repository.getUserProfile();

    result.when(
      success: (response) {
        if (response.status == true && response.data != null) {
          final entity = _mapToEntity(response.data!);
          emit(UserProfileSuccess(entity));
        } else {
          emit(
            UserProfileError(
              response.message ?? 'فشل في تحميل بيانات المستخدم',
            ),
          );
        }
      },
      failure: (error) {
        emit(UserProfileError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  UserProfileEntity _mapToEntity(UserProfileData data) {
    return UserProfileEntity(
      id: data.id,
      name: data.name,
      phone: data.phone,
      email: data.email,
    );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    emit(const UserProfileUpdating());

    final request = UpdateProfileRequest(
      name: name,
      phone: phone,
      email: email,
    );

    final result = await _repository.updateProfile(request);

    result.when(
      success: (response) {
        if (response.status == true) {
          emit(UserProfileUpdateSuccess(response.message ?? 'تم الحفظ بنجاح'));
          loadUserProfile();
        } else {
          emit(
            UserProfileUpdateError(response.message ?? 'فشل في تحديث البيانات'),
          );
        }
      },
      failure: (error) {
        emit(
          UserProfileUpdateError(error.apiErrorModel.message ?? 'حدث خطأ ما'),
        );
      },
    );
  }
}
