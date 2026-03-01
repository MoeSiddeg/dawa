import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/storage_service.dart';
import '../../../../core/value/constant.dart';
import '../../data/models/login_response.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  LoginCubit(this._authRepository, this._storageService)
    : super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.when(
      success: (response) async {
        if (response.status == true && response.data != null) {
          // Save user data to storage
          await _saveUserData(response.data!);
          emit(LoginSuccess(response));
        } else {
          emit(LoginError(response.message ?? 'Login failed'));
        }
      },
      failure: (error) {
        emit(LoginError(error.apiErrorModel.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> _saveUserData(UserData userData) async {
    if (userData.accessToken != null) {
      await _storageService.setSecureToken(userData.accessToken!);
    }
    if (userData.name != null) {
      await _storageService.setString(
        AppConstants.STORAGE_USER_NAME,
        userData.name!,
      );
    }
    if (userData.id != null) {
      await _storageService.setUserId(userData.id!);
    }
  }

  Future<void> loginAsGuest() async {
    emit(const LoginLoading());
    await _storageService.setGuestLogin();
    await _storageService.setString(AppConstants.STORAGE_USER_NAME, 'زائر');
    emit(const LoginGuestSuccess());
  }
}
