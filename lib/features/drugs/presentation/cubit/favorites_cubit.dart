import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/most_viewed_medicine_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repository) : super(const FavoritesState());

  final FavoritesRepository _repository;

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, resetError: true));
    try {
      final favorites = await _repository.getFavorites();
      final ids = favorites.map((item) => item.id).toSet();
      emit(
        state.copyWith(
          isLoading: false,
          favorites: favorites,
          favoriteIds: ids,
          resetError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> toggleFavorite(MostViewedMedicineEntity medicine) async {
    final isCurrentlyFavorite = state.favoriteIds.contains(medicine.id);
    try {
      if (isCurrentlyFavorite) {
        await _repository.removeFavorite(medicine.id);
      } else {
        await _repository.addFavorite(medicine);
      }
      await loadFavorites();
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<bool> isFavorite(int id) async {
    if (state.favoriteIds.contains(id)) {
      return true;
    }
    return _repository.isFavorite(id);
  }
}
