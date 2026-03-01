import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../drugs/domain/entities/most_viewed_medicine_entity.dart';

class DrugCardWidget extends StatelessWidget {
  final MostViewedMedicineEntity medicine;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const DrugCardWidget({
    super.key,
    required this.medicine,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nameAr = medicine.name ?? medicine.tradeName ?? 'دواء غير معروف';
    final nameEn = medicine.tradeName ?? medicine.name;
    final price =
        (medicine.price != null && medicine.price!.isNotEmpty)
            ? '${medicine.price} ج.م'
            : 'السعر غير متوفر';
    final imageUrl = medicine.image;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    imageUrl == null || imageUrl.isEmpty
                        ? const Icon(
                          Icons.medication,
                          color: AppTheme.primaryColor,
                          size: 32,
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            errorWidget:
                                (context, url, error) => const Icon(
                                  Icons.medication,
                                  color: AppTheme.primaryColor,
                                  size: 32,
                                ),
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                          ),
                        ),
              ),
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
                    const SizedBox(height: 4),
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
}
