import '../../../../core/networking/api_result.dart';
import '../../data/models/reset_password_models.dart';

abstract class ResetPasswordRepository {
  Future<ApiResult<ResetPasswordResponse>> sendOtp({required String email});
  Future<ApiResult<ResetPasswordResponse>> verifyOtp({
    required String email,
    required String otp,
  });
  Future<ApiResult<ResetPasswordResponse>> resetPassword({
    required String email,
    required String password,
  });
}
