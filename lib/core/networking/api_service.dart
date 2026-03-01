import 'package:dio/dio.dart' hide Headers;
import 'package:drugvet_master/features/auth/data/models/register_response.dart';
import 'package:drugvet_master/features/ads/data/models/ads_response.dart';
import 'package:drugvet_master/features/companies/data/models/companies_response.dart';
import 'package:drugvet_master/features/companies/data/models/company_details_response.dart';
import 'package:drugvet_master/features/companies/data/models/company_medicines_response.dart';
import 'package:drugvet_master/features/drugs/data/models/most_viewed_medicines_response.dart';
import 'package:drugvet_master/features/drugs/data/models/drug_details_response.dart';
import 'package:drugvet_master/features/doctors/data/models/doctors_response.dart';
import 'package:drugvet_master/features/doctors/data/models/doctor_details_response.dart';
import 'package:drugvet_master/features/doctors/data/models/doctor_categories_response.dart';
import 'package:drugvet_master/features/doctors/data/models/doctors_by_category_response.dart';
import 'package:drugvet_master/features/blog/data/models/blogs_response.dart';
import 'package:drugvet_master/features/blog/data/models/blog_details_response.dart';
import 'package:drugvet_master/features/contact/data/models/send_message_request.dart';
import 'package:drugvet_master/features/contact/data/models/send_message_response.dart';
import 'package:drugvet_master/features/pages/data/models/page_content_response.dart';
import 'package:drugvet_master/features/profile/data/models/user_profile_response.dart';
import 'package:drugvet_master/features/profile/data/models/update_profile_request.dart';
import 'package:drugvet_master/features/profile/data/models/update_profile_response.dart';
import 'package:drugvet_master/features/drugs/data/models/special_medicine_search_response.dart';

import 'package:retrofit/retrofit.dart';

import '../../features/auth/data/models/login_request_body.dart';
import '../../features/auth/data/models/login_response.dart';
import '../../features/auth/data/models/register_request_body.dart';
import '../../features/auth/data/models/reset_password_models.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.apiLoginEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<LoginResponse> login(@Body() LoginRequestBody body);

  @POST(ApiConstants.apiRegisterEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<RegisterResponse> register(@Body() RegisterRequestBody body);

  @GET(ApiConstants.apiAdsEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<AdsResponse> getAds();

  @GET(ApiConstants.apiCompaniesEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<CompaniesResponse> getCompanies({@Query('page') int page = 1});

  @GET('${ApiConstants.apiCompaniesEndpoint}/{id}')
  @Headers({'Content-Language': 'ar'})
  Future<CompanyDetailsResponse> getCompanyDetails(@Path('id') int id);

  @GET('${ApiConstants.apiCompaniesEndpoint}/{id}/medicines')
  @Headers({'Content-Language': 'ar'})
  Future<CompanyMedicinesResponse> getCompanyMedicines(
    @Path('id') int id, {
    @Query('page') int page = 1,
  });

  @GET(ApiConstants.apiMostViewedMedicinesEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<MostViewedMedicinesResponse> getMostViewedMedicines();

  @GET('${ApiConstants.apiMedicinesEndpoint}/{id}')
  @Headers({'Content-Language': 'ar'})
  Future<DrugDetailsResponse> getDrugDetails(@Path('id') int id);

  @GET(ApiConstants.apiDoctorsEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<DoctorsResponse> getDoctors({@Query('page') int page = 1});

  @GET('${ApiConstants.apiDoctorsEndpoint}/{id}')
  @Headers({'Content-Language': 'ar'})
  Future<DoctorDetailsResponse> getDoctorDetails(@Path('id') int id);

  @GET(ApiConstants.apiDoctorCategoriesEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<DoctorCategoriesResponse> getDoctorCategories();

  @GET('${ApiConstants.apiDoctorCategoriesEndpoint}/{categoryId}')
  @Headers({'Content-Language': 'ar'})
  Future<DoctorsByCategoryResponse> getDoctorsByCategory(
    @Path('categoryId') int categoryId,
  );

  @GET(ApiConstants.apiPostsEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<BlogsResponse> getBlogs({@Query('page') int page = 1});

  @GET('${ApiConstants.apiPostsEndpoint}/{id}')
  @Headers({'Content-Language': 'ar'})
  Future<BlogDetailsResponse> getBlogDetails(@Path('id') int id);

  @POST(ApiConstants.apiContactEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<SendMessageResponse> sendMessage(@Body() SendMessageRequest body);

  @GET(ApiConstants.apiAboutUsEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<PageContentResponse> getAboutUs();

  @GET(ApiConstants.apiHelpEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<PageContentResponse> getHelp();

  @GET(ApiConstants.apiPrivacyPolicyEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<PageContentResponse> getPrivacyPolicy();

  @GET(ApiConstants.apiTermsOfUseEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<PageContentResponse> getTermsOfUse();

  @GET('/visitors/{userId}/edit')
  @Headers({'Content-Language': 'ar'})
  Future<UserProfileResponse> getUserProfile(
    @Header('Authorization') String token,
    @Path('userId') String userId,
  );

  @POST('/visitors/{userId}')
  @Headers({'Content-Language': 'ar'})
  Future<UpdateProfileResponse> updateProfile(
    @Header('Authorization') String token,
    @Path('userId') String userId,
    @Body() UpdateProfileRequest body,
  );

  @GET(ApiConstants.apiSpecialMedicinesSearchEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<SpecialMedicineSearchResponse> searchSpecialMedicines({
    @Query('trade_name') String? tradeName,
    @Query('generic_name') String? genericName,
    @Query('dosage_form') String? dosageForm,
    @Query('register_no') String? registerNo,
    @Query('applicant_name') String? applicantName,
    @Query('pharmacological_group') String? pharmacologicalGroup,
    @Query('target_species') String? targetSpecies,
    @Query('page') int page = 1,
  });

  @POST(ApiConstants.apiSendOtpEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<ResetPasswordResponse> sendOtp(@Body() SendOtpRequest body);

  @POST(ApiConstants.apiVerifyOtpEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<ResetPasswordResponse> verifyOtp(@Body() VerifyOtpRequest body);

  @POST(ApiConstants.apiResetPasswordEndpoint)
  @Headers({'Content-Language': 'ar'})
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest body,
  );
}

// doctor classification logic needs to be updated
