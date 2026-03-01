import '../../domain/entities/most_viewed_medicine_entity.dart';

abstract class FavoritesRepository {
  Future<List<MostViewedMedicineEntity>> getFavorites();
  Future<void> addFavorite(MostViewedMedicineEntity medicine);
  Future<void> removeFavorite(int id);
  Future<bool> isFavorite(int id);
}
