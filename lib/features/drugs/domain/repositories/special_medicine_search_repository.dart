import '../../../../core/networking/api_result.dart';
import '../../data/models/special_medicine_search_response.dart';

abstract class SpecialMedicineSearchRepository {
  Future<ApiResult<SpecialMedicineSearchResponse>> searchMedicines({
    String? tradeName,
    String? genericName,
    String? dosageForm,
    String? registerNo,
    String? applicantName,
    String? pharmacologicalGroup,
    String? targetSpecies,
    int page = 1,
  });
}
