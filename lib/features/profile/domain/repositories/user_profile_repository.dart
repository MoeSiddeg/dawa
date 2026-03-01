import '../../../../core/networking/api_result.dart';
import '../../data/models/update_profile_request.dart';
import '../../data/models/update_profile_response.dart';
import '../../data/models/user_profile_response.dart';

abstract class UserProfileRepository {
  Future<ApiResult<UserProfileResponse>> getUserProfile();
  Future<ApiResult<UpdateProfileResponse>> updateProfile(
    UpdateProfileRequest request,
  );
}
