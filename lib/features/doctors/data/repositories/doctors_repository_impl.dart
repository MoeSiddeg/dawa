import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/doctors_repository.dart';
import '../models/doctors_response.dart';
import '../models/doctor_details_response.dart';
import '../models/doctor_categories_response.dart';
import '../models/doctors_by_category_response.dart';

class DoctorsRepositoryImpl extends BaseRepository
    implements DoctorsRepository {
  final ApiService _apiService;

  DoctorsRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<DoctorsResponse>> getDoctors({int page = 1}) {
    return executeApiCall<DoctorsResponse, DoctorsResponse>(
      () => _apiService.getDoctors(page: page),
    );
  }

  @override
  Future<ApiResult<DoctorDetailsResponse>> getDoctorDetails(int id) {
    return executeApiCall<DoctorDetailsResponse, DoctorDetailsResponse>(
      () => _apiService.getDoctorDetails(id),
    );
  }

  @override
  Future<ApiResult<DoctorCategoriesResponse>> getDoctorCategories() {
    return executeApiCall<DoctorCategoriesResponse, DoctorCategoriesResponse>(
      () => _apiService.getDoctorCategories(),
    );
  }

  @override
  Future<ApiResult<DoctorsByCategoryResponse>> getDoctorsByCategory(
    int categoryId,
  ) {
    return executeApiCall<DoctorsByCategoryResponse, DoctorsByCategoryResponse>(
      () => _apiService.getDoctorsByCategory(categoryId),
    );
  }
}
