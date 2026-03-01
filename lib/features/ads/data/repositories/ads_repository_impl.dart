import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/ads_repository.dart';
import '../models/ads_response.dart';

class AdsRepositoryImpl extends BaseRepository implements AdsRepository {
  final ApiService _apiService;

  AdsRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<AdsResponse>> getAds() {
    return executeApiCall<AdsResponse, AdsResponse>(() => _apiService.getAds());
  }
}
