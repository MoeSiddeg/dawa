import '../../../../core/networking/api_result.dart';
import '../../data/models/doctors_response.dart';
import '../../data/models/doctor_details_response.dart';
import '../../data/models/doctor_categories_response.dart';
import '../../data/models/doctors_by_category_response.dart';

abstract class DoctorsRepository {
  Future<ApiResult<DoctorsResponse>> getDoctors({int page = 1});
  Future<ApiResult<DoctorDetailsResponse>> getDoctorDetails(int id);
  Future<ApiResult<DoctorCategoriesResponse>> getDoctorCategories();
  Future<ApiResult<DoctorsByCategoryResponse>> getDoctorsByCategory(
    int categoryId,
  );
}
