import '../../data/models/reset_password_models.dart';

sealed class ResetPasswordState {
  const ResetPasswordState();
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

class SendOtpSuccess extends ResetPasswordState {
  final ResetPasswordResponse response;
  final String email;
  const SendOtpSuccess(this.response, this.email);
}

class VerifyOtpSuccess extends ResetPasswordState {
  final ResetPasswordResponse response;
  final String email;
  const VerifyOtpSuccess(this.response, this.email);
}

class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponse response;
  const ResetPasswordSuccess(this.response);
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  const ResetPasswordError(this.message);
}
