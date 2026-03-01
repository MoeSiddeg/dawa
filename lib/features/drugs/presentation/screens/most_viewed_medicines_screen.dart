import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/most_viewed_medicine_entity.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../cubit/most_viewed_medicines_cubit.dart';
import '../cubit/most_viewed_medicines_state.dart';

class MostViewedMedicinesScreen extends StatefulWidget {
  const MostViewedMedicinesScreen({super.key});

  @override
  State<MostViewedMedicinesScreen> createState() =>
      _MostViewedMedicinesScreenState();
}

class _MostViewedMedicinesScreenState extends State<MostViewedMedicinesScreen> {
  late final MostViewedMedicinesCubit _cubit;
  late final FavoritesCubit _favoritesCubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MostViewedMedicinesCubit>();
    _favoritesCubit = getIt<FavoritesCubit>();
    _favoritesCubit.loadFavorites();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _favoritesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأدوية الأكثر بحثاً'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: BlocBuilder<MostViewedMedicinesCubit, MostViewedMedicinesState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is MostViewedMedicinesLoading ||
              state is MostViewedMedicinesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MostViewedMedicinesError) {
            return _buildError(state.message);
          }

          final medicines =
              state is MostViewedMedicinesSuccess ? state.medicines : const [];

          if (medicines.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('لا توجد أدوية متاحة حالياً'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _cubit.refresh,
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              bloc: _favoritesCubit,
              builder: (context, favState) {
                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    final isFavorite = favState.favoriteIds.contains(
                      medicine.id,
                    );
                    return _buildMedicineCard(
                      medicine,
                      isFavorite: isFavorite,
                      onToggleFavorite:
                          () => _favoritesCubit.toggleFavorite(medicine),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: medicines.length,
                );
              },
            ),
          );
        },
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
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodyLarge.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cubit.loadMostViewedMedicines,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(
    MostViewedMedicineEntity medicine, {
    required bool isFavorite,
    required VoidCallback onToggleFavorite,
  }) {
    final nameAr = medicine.name ?? medicine.tradeName ?? 'دواء غير معروف';
    final nameEn = medicine.tradeName ?? medicine.name;
    final price =
        (medicine.price != null && medicine.price!.isNotEmpty)
            ? '${medicine.price} ج.م'
            : 'السعر غير متوفر';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap:
            () => Navigator.pushNamed(
              context,
              '/drug-details',
              arguments: medicine.id,
            ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildImage(medicine.image),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameAr,
                      style: AppTheme.heading3.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (nameEn != null && nameEn.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        nameEn,
                        style: AppTheme.bodyMedium.copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
              // Favorite Button
              IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const SizedBox(
              width: 70,
              height: 70,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        errorWidget: (context, url, error) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.medication,
        color: AppTheme.primaryColor,
        size: 32,
      ),
    );
  }
}
