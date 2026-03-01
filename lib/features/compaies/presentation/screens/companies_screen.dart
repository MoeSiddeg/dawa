import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ads_widget.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../companies/presentation/cubit/companies_cubit.dart';
import '../../../companies/presentation/cubit/companies_state.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  late final CompaniesCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CompaniesCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadCompanies();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= threshold &&
        !_cubit.isLoadingMore &&
        !_cubit.hasReachedEnd) {
      final nextPage = _cubit.currentPage + 1;
      if (nextPage > 1) {
        _cubit.loadCompanies(page: nextPage);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الشركات'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            BlocBuilder<CompaniesCubit, CompaniesState>(
              bloc: _cubit,
              builder: (context, state) {
                final total =
                    state is CompaniesSuccess
                        ? state.meta?.total ?? state.companies.length
                        : null;
                return _buildHeader(
                  total: total,
                  isLoading: state is CompaniesLoading,
                );
              },
            ),
            const AdsWidget(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CompaniesCubit, CompaniesState>(
                bloc: _cubit,
                builder: (context, state) {
                  if (state is CompaniesLoading || state is CompaniesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CompaniesError) {
                    return _buildError(state.message);
                  }

                  final companies =
                      state is CompaniesSuccess
                          ? state.companies
                          : <CompanyEntity>[];
                  final isLoadingMore =
                      state is CompaniesSuccess && state.isLoadingMore;

                  if (companies.isEmpty) {
                    return const Center(
                      child: Text('لا توجد شركات متاحة حالياً'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: companies.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isLoadingMore && index == companies.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final company = companies[index];
                        return _buildCompanyCard(context, company);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, color: Colors.white),
              tooltip: 'Filter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({int? total, required bool isLoading}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade50,
      width: double.infinity,
      child: Text(
        isLoading
            ? 'جاري تحميل الشركات...'
            : 'عدد الشركات المعروضة: ${total ?? 0}',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodyLarge.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _cubit.loadCompanies(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, CompanyEntity company) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.companyDetails,
            arguments: company.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child:
                      company.logo == null || company.logo!.isEmpty
                          ? Container(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.business,
                              size: 35,
                              color: AppTheme.primaryColor,
                            ),
                          )
                          : Image.network(
                            company.logo!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: const Icon(
                                    Icons.business,
                                    size: 35,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                          ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                company.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      (company.address ?? 'لا يوجد عنوان').split(',').first,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
