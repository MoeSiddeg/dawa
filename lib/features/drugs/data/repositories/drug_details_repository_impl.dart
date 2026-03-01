import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/drug_details_repository.dart';
import '../models/drug_details_response.dart';

class DrugDetailsRepositoryImpl extends BaseRepository
    implements DrugDetailsRepository {
  final ApiService _apiService;

  DrugDetailsRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<DrugDetailsResponse>> getDrugDetails(int id) {
    return executeApiCall<DrugDetailsResponse, DrugDetailsResponse>(
      () => _apiService.getDrugDetails(id),
    );
  }
}
