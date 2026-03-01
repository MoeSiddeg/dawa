import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/reset_password_repository.dart';
import '../models/reset_password_models.dart';

class ResetPasswordRepositoryImpl extends BaseRepository
    implements ResetPasswordRepository {
  final ApiService _apiService;

  ResetPasswordRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<ResetPasswordResponse>> sendOtp({
    required String email,
  }) async {
    return await executeApiCall<ResetPasswordResponse, ResetPasswordResponse>(
      () => _apiService.sendOtp(SendOtpRequest(email: email)),
    );
  }

  @override
  Future<ApiResult<ResetPasswordResponse>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await executeApiCall<ResetPasswordResponse, ResetPasswordResponse>(
      () => _apiService.verifyOtp(VerifyOtpRequest(email: email, otp: otp)),
    );
  }

  @override
  Future<ApiResult<ResetPasswordResponse>> resetPassword({
    required String email,
    required String password,
  }) async {
    return await executeApiCall<ResetPasswordResponse, ResetPasswordResponse>(
      () => _apiService.resetPassword(
        ResetPasswordRequest(email: email, password: password),
      ),
    );
  }
}
