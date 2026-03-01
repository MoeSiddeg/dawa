import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/theme.dart';
import '../../../home/presentation/widgets/advanced_search_bottom_sheet.dart';
import '../../domain/entities/special_medicine_entity.dart';
import '../cubit/special_medicine_search_cubit.dart';
import '../cubit/special_medicine_search_state.dart';

class SpecialMedicineSearchScreen extends StatefulWidget {
  const SpecialMedicineSearchScreen({super.key});

  @override
  State<SpecialMedicineSearchScreen> createState() =>
      _SpecialMedicineSearchScreenState();
}

class _SpecialMedicineSearchScreenState
    extends State<SpecialMedicineSearchScreen> {
  final _quickSearchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _quickSearchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performQuickSearch() {
    if (_quickSearchController.text.trim().isNotEmpty) {
      context.read<SpecialMedicineSearchCubit>().search(
        tradeName: _quickSearchController.text.trim(),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SpecialMedicineSearchCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'البحث المتقدم',
          style: GoogleFonts.tajawal(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildQuickSearchBar(),

          Expanded(
            child: BlocBuilder<
              SpecialMedicineSearchCubit,
              SpecialMedicineSearchState
            >(
              builder: (context, state) {
                if (state is SpecialMedicineSearchInitial) {
                  return _buildInitialState();
                }

                if (state is SpecialMedicineSearchLoading) {
                  return _buildLoadingState();
                }

                if (state is SpecialMedicineSearchError) {
                  return _buildErrorState(state.message);
                }

                if (state is SpecialMedicineSearchEmpty) {
                  return _buildEmptyState();
                }

                if (state is SpecialMedicineSearchSuccess ||
                    state is SpecialMedicineSearchLoadingMore) {
                  final medicines =
                      state is SpecialMedicineSearchSuccess
                          ? state.medicines
                          : (state as SpecialMedicineSearchLoadingMore)
                              .medicines;
                  final isLoadingMore =
                      state is SpecialMedicineSearchLoadingMore;
                  final totalItems =
                      state is SpecialMedicineSearchSuccess
                          ? state.totalItems
                          : 0;

                  return _buildResultsList(
                    medicines,
                    isLoadingMore: isLoadingMore,
                    totalItems: totalItems,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: _quickSearchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performQuickSearch(),
          decoration: InputDecoration(
            hintText: 'ابحث عن دواء، مادة فعالة، أو شركة...',
            hintStyle: const TextStyle(color: AppTheme.textTertiary),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search, color: AppTheme.primaryColor),
              onPressed: _performQuickSearch,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune, color: AppTheme.primaryColor),
              onPressed: () => AdvancedSearchBottomSheet.show(context),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'البحث المتقدم عن الأدوية',
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'استخدم الفلاتر أعلاه للبحث عن الأدوية\nبالاسم التجاري أو العلمي أو التركيب',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryColor),
          SizedBox(height: 16),
          Text('جاري البحث...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ',
              style: AppTheme.heading2.copyWith(color: AppTheme.errorColor),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<SpecialMedicineSearchCubit>().refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: AppTheme.warningColor,
              ),
            ),
            const SizedBox(height: 24),
            Text('لا توجد نتائج', style: AppTheme.heading2),
            const SizedBox(height: 12),
            Text(
              'لم يتم العثور على أدوية تطابق معايير البحث\nجرب تغيير الفلاتر',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(
    List<SpecialMedicineEntity> medicines, {
    required bool isLoadingMore,
    required int totalItems,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.medication,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$totalItems نتيجة',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh:
                () => context.read<SpecialMedicineSearchCubit>().refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: medicines.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == medicines.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMedicineCard(medicines[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard(SpecialMedicineEntity medicine) {
    final displayName = medicine.name ?? medicine.tradeName ?? 'دواء غير معروف';
    final secondaryName = medicine.tradeName ?? medicine.name;
    final price =
        (medicine.price != null && medicine.price!.isNotEmpty)
            ? '${medicine.price} ج.م'
            : 'السعر غير متوفر';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap:
            () => Navigator.pushNamed(
              context,
              '/drug-details',
              arguments: medicine.id,
            ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildMedicineImage(medicine.image),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTheme.heading3.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (secondaryName != null &&
                        secondaryName.isNotEmpty &&
                        secondaryName != displayName) ...[
                      const SizedBox(height: 4),
                      Text(
                        secondaryName,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (medicine.dosageForm != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              medicine.dosageForm!,
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.secondaryColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (medicine.applicant != null)
                          Expanded(
                            child: Text(
                              medicine.applicant!,
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildImagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
        errorWidget: (context, url, error) => _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.medication,
        color: AppTheme.primaryColor,
        size: 36,
      ),
    );
  }
}
