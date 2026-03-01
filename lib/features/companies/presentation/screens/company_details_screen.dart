import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/company_details_entity.dart';
import '../cubit/company_details_cubit.dart';
import '../cubit/company_details_state.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final int companyId;

  const CompanyDetailsScreen({super.key, required this.companyId});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  late final CompanyDetailsCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CompanyDetailsCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadCompany(widget.companyId);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= threshold) {
      _cubit.loadMoreMedicines(widget.companyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الشركة')),
      body: BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is CompanyDetailsLoading ||
              state is CompanyDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompanyDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTheme.bodyLarge.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.loadCompany(widget.companyId),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          final successState = state as CompanyDetailsSuccess;
          final company = successState.company;
          final medicines = successState.medicines;
          final isLoadingMore = successState.isLoadingMore;
          final hasReachedEnd = successState.hasReachedEnd;
          final paginationError = successState.paginationError;

          return RefreshIndicator(
            onRefresh: () => _cubit.refreshCompany(company.id),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(company)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                if (medicines.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('لا توجد منتجات متاحة حالياً'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final medicine = medicines[index];
                        return _buildProductCard(context, medicine);
                      }, childCount: medicines.length),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        if (isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: CircularProgressIndicator(),
                          ),
                        if (paginationError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  paginationError,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed:
                                      () =>
                                          _cubit.loadMoreMedicines(company.id),
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          ),
                        if (!hasReachedEnd &&
                            medicines.isNotEmpty &&
                            !isLoadingMore)
                          Text(
                            'اسحب لأسفل لرؤية المزيد...',
                            style: AppTheme.bodySmall.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(CompanyDetailsEntity company) {
    final displayName =
        company.name.trim().isNotEmpty
            ? company.name
            : (company.alias ?? 'اسم غير متوفر');
    final secondaryName =
        (company.alias != null && company.alias!.isNotEmpty)
            ? company.alias
            : null;

    final locationParts = <String>[];
    final address = company.address?.trim();
    if (address != null && address.isNotEmpty) {
      locationParts.add(address);
    }
    final governorateName = company.governorate?.name?.trim();
    if (governorateName != null && governorateName.isNotEmpty) {
      locationParts.add(governorateName);
    }
    final countryName = company.country?.name?.trim();
    if (countryName != null && countryName.isNotEmpty) {
      locationParts.add(countryName);
    }
    final location = locationParts.isEmpty ? null : locationParts.join(', ');
    final phone = company.phone ?? company.mobile;
    final email = company.responsableEmail ?? company.user?.email;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5A5A5A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: company.logo ?? '',
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.business,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.business,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (secondaryName != null && secondaryName != displayName)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                secondaryName,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
          if (location != null && location.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    location,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          if (phone != null && phone.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  phone,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
          if (email != null && email.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    CompanyMedicineEntity medicine,
  ) {
    final nameAr = medicine.nameAr ?? medicine.nameEn ?? 'منتج غير معروف';
    final nameEn = medicine.nameEn;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.secondaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child:
                  (medicine.image != null && medicine.image!.isNotEmpty)
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: medicine.image!,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.medication,
                                  size: 40,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.medication,
                                  size: 40,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                        ),
                      )
                      : const Icon(
                        Icons.medication,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  nameAr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (nameEn != null && nameEn.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    nameEn,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/drug-details',
                        arguments: medicine.id,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: AppTheme.textSecondary,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'التفاصيل',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
