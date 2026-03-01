import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/companies_repository.dart';
import '../models/companies_response.dart';
import '../models/company_details_response.dart';
import '../models/company_medicines_response.dart';

class CompaniesRepositoryImpl extends BaseRepository
    implements CompaniesRepository {
  final ApiService _apiService;

  CompaniesRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<CompaniesResponse>> getCompanies({int page = 1}) {
    return executeApiCall<CompaniesResponse, CompaniesResponse>(
      () => _apiService.getCompanies(page: page),
    );
  }

  @override
  Future<ApiResult<CompanyDetailsResponse>> getCompanyDetails(int id) {
    return executeApiCall<CompanyDetailsResponse, CompanyDetailsResponse>(
      () => _apiService.getCompanyDetails(id),
    );
  }

  @override
  Future<ApiResult<CompanyMedicinesResponse>> getCompanyMedicines({
    required int companyId,
    int page = 1,
  }) {
    return executeApiCall<CompanyMedicinesResponse, CompanyMedicinesResponse>(
      () => _apiService.getCompanyMedicines(companyId, page: page),
    );
  }
}
