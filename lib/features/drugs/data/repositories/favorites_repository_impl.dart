import '../../domain/entities/most_viewed_medicine_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<void> addFavorite(MostViewedMedicineEntity medicine) {
    return _localDataSource.addFavorite(medicine);
  }

  @override
  Future<List<MostViewedMedicineEntity>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  @override
  Future<bool> isFavorite(int id) {
    return _localDataSource.isFavorite(id);
  }

  @override
  Future<void> removeFavorite(int id) {
    return _localDataSource.removeFavorite(id);
  }
}
