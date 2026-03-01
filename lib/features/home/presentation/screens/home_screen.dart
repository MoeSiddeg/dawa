import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../../companies/presentation/cubit/companies_cubit.dart';
import '../../../doctors/presentation/cubit/doctors_cubit.dart';
import '../../../drugs/presentation/cubit/favorites_cubit.dart';
import '../../../drugs/presentation/cubit/most_viewed_medicines_cubit.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../pages/home_pages.dart';
import 'consultant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  final _companySearchController = TextEditingController();
  late final CompaniesCubit _companiesCubit;
  late final MostViewedMedicinesCubit _mostViewedMedicinesCubit;
  late final FavoritesCubit _favoritesCubit;
  late final DoctorsCubit _doctorsCubit;
  late final UserProfileCubit _userProfileCubit;

  @override
  void initState() {
    super.initState();
    _companiesCubit = getIt<CompaniesCubit>();
    _companiesCubit.loadCompanies();
    _mostViewedMedicinesCubit = getIt<MostViewedMedicinesCubit>();
    _mostViewedMedicinesCubit.loadMostViewedMedicines();
    _favoritesCubit = getIt<FavoritesCubit>();
    _favoritesCubit.loadFavorites();
    _doctorsCubit = getIt<DoctorsCubit>();
    _doctorsCubit.loadDoctors();
    _userProfileCubit = getIt<UserProfileCubit>();
    _userProfileCubit.loadUserProfile();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _companySearchController.dispose();
    _favoritesCubit.close();
    _mostViewedMedicinesCubit.close();
    super.dispose();
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeTabPage(
          searchController: _searchController,
          mostViewedMedicinesCubit: _mostViewedMedicinesCubit,
          favoritesCubit: _favoritesCubit,
          companiesCubit: _companiesCubit,
          doctorsCubit: _doctorsCubit,
          onShowAllCompanies: () => setState(() => _selectedIndex = 1),
          onShowAllDoctors: () => setState(() => _selectedIndex = 3),
        );
      case 1:
        return CompaniesTabPage(
          companySearchController: _companySearchController,
          companiesCubit: _companiesCubit,
          onSearchChanged: () => setState(() {}),
        );
      case 2:
        return FavoritesTabPage(favoritesCubit: _favoritesCubit);
      case 3:
        return const ConsultantScreen();
      default:
        return ProfileTabPage(userProfileCubit: _userProfileCubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined),
              activeIcon: Icon(Icons.business),
              label: 'الشركات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services_outlined),
              activeIcon: Icon(Icons.medical_services),
              label: 'مستشارك',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'الحساب',
            ),
          ],
        ),
      ),
    );
  }
}
