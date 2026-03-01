import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../companies/presentation/cubit/companies_cubit.dart';
import '../../../doctors/presentation/cubit/doctors_cubit.dart';
import '../../../drugs/presentation/cubit/favorites_cubit.dart';
import '../../../drugs/presentation/cubit/most_viewed_medicines_cubit.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';

class HomeController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController companySearchController = TextEditingController();

  late final CompaniesCubit companiesCubit;
  late final MostViewedMedicinesCubit mostViewedMedicinesCubit;
  late final FavoritesCubit favoritesCubit;
  late final DoctorsCubit doctorsCubit;
  late final UserProfileCubit userProfileCubit;

  int selectedIndex = 0;

  void init() {
    companiesCubit = getIt<CompaniesCubit>();
    companiesCubit.loadCompanies();
    mostViewedMedicinesCubit = getIt<MostViewedMedicinesCubit>();
    mostViewedMedicinesCubit.loadMostViewedMedicines();
    favoritesCubit = getIt<FavoritesCubit>();
    favoritesCubit.loadFavorites();
    doctorsCubit = getIt<DoctorsCubit>();
    doctorsCubit.loadDoctors();
    userProfileCubit = getIt<UserProfileCubit>();
    userProfileCubit.loadUserProfile();
  }

  void dispose() {
    searchController.dispose();
    companySearchController.dispose();
    favoritesCubit.close();
    mostViewedMedicinesCubit.close();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
  }
}
