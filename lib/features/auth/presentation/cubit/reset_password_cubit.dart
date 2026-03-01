import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/reset_password_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository _repository;

  ResetPasswordCubit(this._repository) : super(const ResetPasswordInitial());

  Future<void> sendOtp({required String email}) async {
    emit(const ResetPasswordLoading());

    final result = await _repository.sendOtp(email: email);

    result.when(
      success: (response) {
        emit(SendOtpSuccess(response, email));
      },
      failure: (error) {
        emit(ResetPasswordError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(const ResetPasswordLoading());

    final result = await _repository.verifyOtp(email: email, otp: otp);

    result.when(
      success: (response) {
        emit(VerifyOtpSuccess(response, email));
      },
      failure: (error) {
        emit(ResetPasswordError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  Future<void> resetPassword({
    required String email,
    required String password,
  }) async {
    emit(const ResetPasswordLoading());

    final result = await _repository.resetPassword(
      email: email,
      password: password,
    );

    result.when(
      success: (response) {
        emit(ResetPasswordSuccess(response));
      },
      failure: (error) {
        emit(ResetPasswordError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  void reset() {
    emit(const ResetPasswordInitial());
  }
}
