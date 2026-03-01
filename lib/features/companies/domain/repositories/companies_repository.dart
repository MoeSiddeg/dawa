import '../../../../core/networking/api_result.dart';
import '../../data/models/companies_response.dart';
import '../../data/models/company_details_response.dart';
import '../../data/models/company_medicines_response.dart';

abstract class CompaniesRepository {
  Future<ApiResult<CompaniesResponse>> getCompanies({int page = 1});
  Future<ApiResult<CompanyDetailsResponse>> getCompanyDetails(int id);
  Future<ApiResult<CompanyMedicinesResponse>> getCompanyMedicines({
    required int companyId,
    int page = 1,
  });
}
