import 'package:drugvet_master/features/auth/data/models/register_request_body.dart';

import 'package:drugvet_master/features/auth/data/models/register_response.dart';

import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request_body.dart';
import '../models/login_response.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    return await executeApiCall<LoginResponse, LoginResponse>(
      () =>
          _apiService.login(LoginRequestBody(email: email, password: password)),
    );
  }

  @override
  Future<ApiResult<RegisterResponse>> register({
    required RegisterRequestBody body,
  }) {
    return executeApiCall<RegisterResponse, RegisterResponse>(
      () => _apiService.register(body),
    );
  }
}
