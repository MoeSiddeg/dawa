import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ads_widget.dart';
import '../../../companies/presentation/cubit/companies_cubit.dart';
import '../../../companies/presentation/cubit/companies_state.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import '../../../doctors/presentation/cubit/doctors_cubit.dart';
import '../../../doctors/presentation/cubit/doctors_state.dart';
import '../../../drugs/presentation/cubit/favorites_cubit.dart';
import '../../../drugs/presentation/cubit/favorites_state.dart';
import '../../../drugs/presentation/cubit/most_viewed_medicines_cubit.dart';
import '../../../drugs/presentation/cubit/most_viewed_medicines_state.dart';
import '../../../drugs/presentation/cubit/special_medicine_search_cubit.dart';
import '../widgets/home_widgets.dart';

class HomeTabPage extends StatelessWidget {
  final TextEditingController searchController;
  final MostViewedMedicinesCubit mostViewedMedicinesCubit;
  final FavoritesCubit favoritesCubit;
  final CompaniesCubit companiesCubit;
  final DoctorsCubit doctorsCubit;
  final VoidCallback onShowAllCompanies;
  final VoidCallback onShowAllDoctors;

  const HomeTabPage({
    super.key,
    required this.searchController,
    required this.mostViewedMedicinesCubit,
    required this.favoritesCubit,
    required this.companiesCubit,
    required this.doctorsCubit,
    required this.onShowAllCompanies,
    required this.onShowAllDoctors,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              final cubit = getIt<SpecialMedicineSearchCubit>();
                              cubit.search(tradeName: value.trim());
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.specialMedicineSearch,
                                (route) => route.settings.name == Routes.home,
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'ابحث عن دواء، مادة فعالة، أو شركة...',
                            hintStyle: const TextStyle(
                              color: AppTheme.textTertiary,
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () {
                                if (searchController.text.trim().isNotEmpty) {
                                  final cubit =
                                      getIt<SpecialMedicineSearchCubit>();
                                  cubit.search(
                                    tradeName: searchController.text.trim(),
                                  );
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.specialMedicineSearch,
                                    (route) =>
                                        route.settings.name == Routes.home,
                                  );
                                }
                              },
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.tune,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () {
                                AdvancedSearchBottomSheet.show(context);
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الأدوية الأكثر بحثاً', style: AppTheme.heading2),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.mostViewedMedicines,
                        );
                      },
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: AdsWidget(position: 1)),
        BlocBuilder<MostViewedMedicinesCubit, MostViewedMedicinesState>(
          bloc: mostViewedMedicinesCubit,
          builder: (context, state) {
            if (state is MostViewedMedicinesLoading ||
                state is MostViewedMedicinesInitial) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (state is MostViewedMedicinesError) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: AppTheme.bodyLarge.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed:
                            mostViewedMedicinesCubit.loadMostViewedMedicines,
                        child: const Text('إعادة المحاولة'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }

            final medicines =
                state is MostViewedMedicinesSuccess
                    ? state.medicines
                    : const [];

            if (medicines.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('لا توجد أدوية متاحة حالياً')),
                ),
              );
            }

            final topMedicines = medicines.take(5).toList();

            return BlocBuilder<FavoritesCubit, FavoritesState>(
              bloc: favoritesCubit,
              builder: (context, favState) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final medicine = topMedicines[index];
                      final isFavorite = favState.favoriteIds.contains(
                        medicine.id,
                      );
                      return DrugCardWidget(
                        medicine: medicine,
                        isFavorite: isFavorite,
                        onToggleFavorite:
                            () => favoritesCubit.toggleFavorite(medicine),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/drug-details',
                            arguments: medicine.id,
                          );
                        },
                      );
                    }, childCount: topMedicines.length),
                  ),
                );
              },
            );
          },
        ),
        const SliverToBoxAdapter(child: AdsWidget(position: 2)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الشركات الأكثر زيارة', style: AppTheme.heading2),
                    TextButton(
                      onPressed: onShowAllCompanies,
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        BlocBuilder<CompaniesCubit, CompaniesState>(
          bloc: companiesCubit,
          builder: (context, state) {
            if (state is CompaniesLoading || state is CompaniesInitial) {
              return _buildCompaniesLoading();
            }

            if (state is CompaniesError) {
              return _buildCompaniesError(state.message);
            }

            if (state is CompaniesEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }

            final companies = (state as CompaniesSuccess).companies;
            final topCompanies = companies.take(5).toList();

            if (topCompanies.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final company = topCompanies[index];
                  return CompanyCardWidget(
                    name: company.name,
                    displayName: company.name,
                    location: company.address ?? 'لا يوجد عنوان',
                    logo: company.logo,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.companyDetails,
                        arguments: company.id,
                      );
                    },
                  );
                }, childCount: topCompanies.length),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: AdsWidget(position: 1)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الاستشاريين', style: AppTheme.heading2),
                    TextButton(
                      onPressed: onShowAllDoctors,
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        BlocBuilder<DoctorsCubit, DoctorsState>(
          bloc: doctorsCubit,
          builder: (context, state) {
            if (state is DoctorsLoading || state is DoctorsInitial) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (state is DoctorsError) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: AppTheme.bodyLarge.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: doctorsCubit.loadDoctors,
                        child: const Text('إعادة المحاولة'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }

            final doctors =
                state is DoctorsSuccess ? state.doctors : <DoctorEntity>[];

            if (doctors.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('لا يوجد أطباء متاحين حالياً')),
                ),
              );
            }

            final topDoctors = doctors.take(5).toList();

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final doctor = topDoctors[index];
                  return DoctorCardWidget(
                    doctor: doctor,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/doctor-details',
                        arguments: doctor.id,
                      );
                    },
                  );
                }, childCount: topDoctors.length),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildCompaniesLoading() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompaniesError(String message) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTheme.bodyLarge.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
