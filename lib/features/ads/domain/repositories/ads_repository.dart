import '../../../../core/networking/api_result.dart';
import '../../data/models/ads_response.dart';

abstract class AdsRepository {
  Future<ApiResult<AdsResponse>> getAds();
}
