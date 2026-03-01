class ApiConstants {
  static const String apiBaseUrl = "https://drugvet.sherifshalaby.tech/api/v1";
  static const String apiLoginEndpoint = "/login";
  static const String apiRegisterEndpoint = "/visitors/store";
  static const String apiAdsEndpoint = "/ads";
  static const String apiCompaniesEndpoint = "/companies";
  static const String apiMostViewedMedicinesEndpoint =
      "/medicines?sort=views_desc";
  static const String apiMedicinesEndpoint = "/medicines";
  static const String apiDoctorsEndpoint = "/doctors";
  static const String apiDoctorCategoriesEndpoint = "/doctor_categories";
  static String apiDoctorsByCategoryEndpoint(int categoryId) =>
      "/doctor_categories/$categoryId";
  static const String apiPostsEndpoint = "/posts";
  static const String apiContactEndpoint = "/contact";
  static const String apiAboutUsEndpoint = "/pages/about_us";
  static const String apiHelpEndpoint = "/pages/help";
  static const String apiPrivacyPolicyEndpoint = "/pages/privacy_policy";
  static const String apiTermsOfUseEndpoint = "/pages/terms_of_use";
  static String apiVisitorsEndpoint(String userId) => "/visitors/$userId/edit";
  static String apiUpdateVisitorEndpoint(String userId) => "/visitors/$userId";
  static const String apiSpecialMedicinesSearchEndpoint =
      "/medicines/special/search";
  static const String apiSendOtpEndpoint = "/password/send-otp";
  static const String apiVerifyOtpEndpoint = "/password/verify-otp";
  static const String apiResetPasswordEndpoint = "/password/reset-password";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String created = "created";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
