import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/ads/data/repositories/ads_repository_impl.dart';
import '../../features/ads/domain/repositories/ads_repository.dart';
import '../../features/ads/presentation/cubit/ads_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/reset_password_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/reset_password_repository.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password_cubit.dart';
import '../../features/companies/data/repositories/companies_repository_impl.dart';
import '../../features/companies/domain/repositories/companies_repository.dart';
import '../../features/companies/presentation/cubit/companies_cubit.dart';
import '../../features/companies/presentation/cubit/company_details_cubit.dart';
import '../../features/drugs/data/datasources/favorites_local_data_source.dart';
import '../../features/drugs/data/repositories/favorites_repository_impl.dart';
import '../../features/drugs/data/repositories/most_viewed_medicines_repository_impl.dart';
import '../../features/drugs/data/repositories/drug_details_repository_impl.dart';
import '../../features/drugs/data/repositories/special_medicine_search_repository_impl.dart';
import '../../features/drugs/domain/repositories/favorites_repository.dart';
import '../../features/drugs/domain/repositories/most_viewed_medicines_repository.dart';
import '../../features/drugs/domain/repositories/drug_details_repository.dart';
import '../../features/drugs/domain/repositories/special_medicine_search_repository.dart';
import '../../features/drugs/presentation/cubit/favorites_cubit.dart';
import '../../features/drugs/presentation/cubit/most_viewed_medicines_cubit.dart';
import '../../features/drugs/presentation/cubit/drug_details_cubit.dart';
import '../../features/drugs/presentation/cubit/special_medicine_search_cubit.dart';
import '../../features/doctors/data/repositories/doctors_repository_impl.dart';
import '../../features/doctors/domain/repositories/doctors_repository.dart';
import '../../features/doctors/presentation/cubit/doctors_cubit.dart';
import '../../features/doctors/presentation/cubit/doctor_details_cubit.dart';
import '../../features/doctors/presentation/cubit/category_doctors_cubit.dart';
import '../../features/blog/data/repositories/blogs_repository_impl.dart';
import '../../features/blog/domain/repositories/blogs_repository.dart';
import '../../features/blog/presentation/cubit/blogs_cubit.dart';
import '../../features/blog/presentation/cubit/blog_details_cubit.dart';
import '../../features/contact/data/repositories/contact_repository_impl.dart';
import '../../features/contact/domain/repositories/contact_repository.dart';
import '../../features/contact/presentation/cubit/contact_cubit.dart';
import '../../features/pages/data/repositories/pages_repository_impl.dart';
import '../../features/pages/domain/repositories/pages_repository.dart';
import '../../features/pages/presentation/cubit/page_content_cubit.dart';
import '../../features/profile/data/repositories/user_profile_repository_impl.dart';
import '../../features/profile/domain/repositories/user_profile_repository.dart';
import '../../features/profile/presentation/cubit/user_profile_cubit.dart';
import '../../global.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../service/database_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // Database
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // Auth
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiService>()),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<AuthRepository>(), Global.storageService),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<AuthRepository>(), Global.storageService),
  );

  // Reset Password
  getIt.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(getIt<ResetPasswordRepository>()),
  );

  // Ads
  getIt.registerLazySingleton<AdsRepository>(
    () => AdsRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AdsCubit>(() => AdsCubit(getIt<AdsRepository>()));

  // Companies
  getIt.registerLazySingleton<CompaniesRepository>(
    () => CompaniesRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CompaniesCubit>(
    () => CompaniesCubit(getIt<CompaniesRepository>()),
  );
  getIt.registerLazySingleton<CompanyDetailsCubit>(
    () => CompanyDetailsCubit(getIt<CompaniesRepository>()),
  );

  // Drugs
  getIt.registerLazySingleton<MostViewedMedicinesRepository>(
    () => MostViewedMedicinesRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<MostViewedMedicinesCubit>(
    () => MostViewedMedicinesCubit(getIt<MostViewedMedicinesRepository>()),
  );
  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSource(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt<FavoritesLocalDataSource>()),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(getIt<FavoritesRepository>()),
  );

  // Drug Details
  getIt.registerLazySingleton<DrugDetailsRepository>(
    () => DrugDetailsRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<DrugDetailsCubit>(
    () => DrugDetailsCubit(getIt<DrugDetailsRepository>()),
  );

  // Special Medicine Search
  getIt.registerLazySingleton<SpecialMedicineSearchRepository>(
    () => SpecialMedicineSearchRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SpecialMedicineSearchCubit>(
    () => SpecialMedicineSearchCubit(getIt<SpecialMedicineSearchRepository>()),
  );

  // Doctors
  getIt.registerLazySingleton<DoctorsRepository>(
    () => DoctorsRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<DoctorsCubit>(
    () => DoctorsCubit(getIt<DoctorsRepository>()),
  );
  getIt.registerFactory<DoctorDetailsCubit>(
    () => DoctorDetailsCubit(getIt<DoctorsRepository>()),
  );
  getIt.registerFactory<CategoryDoctorsCubit>(
    () => CategoryDoctorsCubit(getIt<DoctorsRepository>()),
  );

  // Blogs
  getIt.registerLazySingleton<BlogsRepository>(
    () => BlogsRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<BlogsCubit>(() => BlogsCubit(getIt<BlogsRepository>()));
  getIt.registerFactory<BlogDetailsCubit>(
    () => BlogDetailsCubit(getIt<BlogsRepository>()),
  );

  // Contact
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<ContactCubit>(
    () => ContactCubit(getIt<ContactRepository>()),
  );

  // Pages (About, Help, Privacy Policy, Terms of Use)
  getIt.registerLazySingleton<PagesRepository>(
    () => PagesRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<PageContentCubit>(
    () => PageContentCubit(getIt<PagesRepository>()),
  );

  // User Profile
  getIt.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<UserProfileCubit>(
    () => UserProfileCubit(getIt<UserProfileRepository>()),
  );
}
