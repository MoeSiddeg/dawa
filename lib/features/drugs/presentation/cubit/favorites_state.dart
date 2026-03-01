import '../../domain/entities/most_viewed_medicine_entity.dart';

class FavoritesState {
  final bool isLoading;
  final List<MostViewedMedicineEntity> favorites;
  final Set<int> favoriteIds;
  final String? error;

  const FavoritesState({
    this.isLoading = false,
    this.favorites = const [],
    this.favoriteIds = const <int>{},
    this.error,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<MostViewedMedicineEntity>? favorites,
    Set<int>? favoriteIds,
    String? error,
    bool resetError = false,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      error: resetError ? null : (error ?? this.error),
    );
  }
}
