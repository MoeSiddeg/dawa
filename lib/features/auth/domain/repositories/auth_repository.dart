import '../../../../core/networking/api_result.dart';
import '../../data/models/login_response.dart';
import '../../data/models/register_response.dart';
import '../../data/models/register_request_body.dart';

abstract class AuthRepository {
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  });
  Future<ApiResult<RegisterResponse>> register({
    required RegisterRequestBody body,
  });
}
