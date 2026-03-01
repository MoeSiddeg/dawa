import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../drugs/presentation/cubit/favorites_cubit.dart';
import '../../../drugs/presentation/cubit/favorites_state.dart';
import '../widgets/home_widgets.dart';

class FavoritesTabPage extends StatelessWidget {
  final FavoritesCubit favoritesCubit;

  const FavoritesTabPage({super.key, required this.favoritesCubit});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: favoritesCubit,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = state.favorites;

          if (favorites.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('الأدوية المفضلة', style: AppTheme.heading2),
                const SizedBox(height: 40),
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'لم تقم بإضافة أي أدوية للمفضلة بعد',
                  style: AppTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text('الأدوية المفضلة', style: AppTheme.heading2);
              }
              final medicine = favorites[index - 1];
              return DrugCardWidget(
                medicine: medicine,
                isFavorite: true,
                onToggleFavorite: () => favoritesCubit.toggleFavorite(medicine),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/drug-details',
                    arguments: medicine.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
