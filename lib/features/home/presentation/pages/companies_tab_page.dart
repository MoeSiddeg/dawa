import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../companies/presentation/cubit/companies_cubit.dart';
import '../../../companies/presentation/cubit/companies_state.dart';
import '../widgets/home_widgets.dart';

class CompaniesTabPage extends StatelessWidget {
  final TextEditingController companySearchController;
  final CompaniesCubit companiesCubit;
  final VoidCallback onSearchChanged;

  const CompaniesTabPage({
    super.key,
    required this.companySearchController,
    required this.companiesCubit,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: companySearchController,
                    onChanged: (_) => onSearchChanged(),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن شركة...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CompaniesCubit, CompaniesState>(
              bloc: companiesCubit,
              builder: (context, state) {
                if (state is CompaniesLoading || state is CompaniesInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CompaniesError) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: AppTheme.bodyLarge.copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => companiesCubit.loadCompanies(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final companies =
                    state is CompaniesSuccess
                        ? state.companies
                        : <CompanyEntity>[];

                final query = companySearchController.text.trim();
                final filteredCompanies =
                    query.isEmpty
                        ? companies
                        : companies
                            .where(
                              (company) =>
                                  company.name.toLowerCase().contains(
                                    query.toLowerCase(),
                                  ) ||
                                  (company.alias ?? '').toLowerCase().contains(
                                    query.toLowerCase(),
                                  ),
                            )
                            .toList();

                if (filteredCompanies.isEmpty) {
                  return const Center(
                    child: Text('لا توجد شركات متاحة حالياً'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = filteredCompanies[index];
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
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
