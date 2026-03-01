import 'package:drugvet_master/global.dart';

import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/update_profile_request.dart';
import '../models/update_profile_response.dart';
import '../models/user_profile_response.dart';

class UserProfileRepositoryImpl extends BaseRepository
    implements UserProfileRepository {
  final ApiService _apiService;

  UserProfileRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<UserProfileResponse>> getUserProfile() async {
    return executeApiCall(
      () => _apiService.getUserProfile(
        'Bearer ${Global.storageService.getUserToken()}',
        Global.storageService.getUserId(),
      ),
    );
  }

  @override
  Future<ApiResult<UpdateProfileResponse>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    return executeApiCall(
      () => _apiService.updateProfile(
        'Bearer ${Global.storageService.getUserToken()}',
        Global.storageService.getUserId(),
        request,
      ),
    );
  }
}
