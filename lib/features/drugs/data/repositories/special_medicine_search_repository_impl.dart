import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/special_medicine_search_repository.dart';
import '../models/special_medicine_search_response.dart';

class SpecialMedicineSearchRepositoryImpl extends BaseRepository
    implements SpecialMedicineSearchRepository {
  final ApiService _apiService;

  SpecialMedicineSearchRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<SpecialMedicineSearchResponse>> searchMedicines({
    String? tradeName,
    String? genericName,
    String? dosageForm,
    String? registerNo,
    String? applicantName,
    String? pharmacologicalGroup,
    String? targetSpecies,
    int page = 1,
  }) {
    return executeApiCall<
      SpecialMedicineSearchResponse,
      SpecialMedicineSearchResponse
    >(
      () => _apiService.searchSpecialMedicines(
        tradeName: tradeName,
        genericName: genericName,
        dosageForm: dosageForm,
        registerNo: registerNo,
        applicantName: applicantName,
        pharmacologicalGroup: pharmacologicalGroup,
        targetSpecies: targetSpecies,
        page: page,
      ),
    );
  }
}
