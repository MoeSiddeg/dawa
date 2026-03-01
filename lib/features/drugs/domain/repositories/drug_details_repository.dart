import '../../../../core/networking/api_result.dart';
import '../../data/models/drug_details_response.dart';

abstract class DrugDetailsRepository {
  Future<ApiResult<DrugDetailsResponse>> getDrugDetails(int id);
}
