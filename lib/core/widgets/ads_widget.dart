import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../di/dependency_injection.dart';
import '../../features/ads/domain/entities/ad_entity.dart';
import '../../features/ads/presentation/cubit/ads_cubit.dart';
import '../../features/ads/presentation/cubit/ads_state.dart';
import '../theme/theme.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key, this.position});

  final int? position;

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  late final AdsCubit _adsCubit;

  @override
  void initState() {
    super.initState();
    _adsCubit = getIt<AdsCubit>();
    _adsCubit.loadAds();
  }

  @override
  void dispose() {
    _adsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _adsCubit,
      child: BlocBuilder<AdsCubit, AdsState>(
        builder: (context, state) {
          if (state is AdsLoading || state is AdsInitial) {
            return _buildLoading();
          }

          if (state is AdsError) {
            return _buildError(state.message);
          }

          if (state is AdsEmpty) {
            return const SizedBox.shrink();
          }

          if (state is AdsSuccess) {
            final ads =
                widget.position == null
                    ? state.ads
                    : state.ads
                        .where((ad) => ad.position == widget.position)
                        .toList();

            if (ads.isEmpty) {
              return const SizedBox.shrink();
            }

            return _buildAdsSlider(ads);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16),
          Expanded(
            child: Text('جاري تحميل الإعلانات...', style: AppTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTheme.bodyLarge.copyWith(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdsSlider(List<AdEntity> ads) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: ads.length,
            itemBuilder: (context, index, realIndex) {
              final ad = ads[index];
              return GestureDetector(
                onTap: () async {
                  if (ad.link.isNotEmpty) {
                    final uri = Uri.tryParse(ad.link);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        ad.image,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Container(color: Colors.grey.shade200),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 160,
              autoPlay: ads.length > 1,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
          ),
        ],
      ),
    );
  }
}
