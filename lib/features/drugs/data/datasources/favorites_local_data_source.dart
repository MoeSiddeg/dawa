import 'package:sqflite/sqflite.dart';

import '../../../../core/service/database_service.dart';
import '../../domain/entities/most_viewed_medicine_entity.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource(this._databaseService);

  final DatabaseService _databaseService;

  Future<List<MostViewedMedicineEntity>> getFavorites() async {
    final db = await _databaseService.database;
    final result = await db.query(DatabaseService.favoritesTable);
    return result.map(_mapRowToEntity).toList(growable: false);
  }

  Future<void> addFavorite(MostViewedMedicineEntity medicine) async {
    final db = await _databaseService.database;
    await db.insert(
      DatabaseService.favoritesTable,
      _mapEntityToRow(medicine),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      DatabaseService.favoritesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {
    final db = await _databaseService.database;
    final result = await db.query(
      DatabaseService.favoritesTable,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Map<String, dynamic> _mapEntityToRow(MostViewedMedicineEntity medicine) {
    return {
      'id': medicine.id,
      'name': medicine.name,
      'trade_name': medicine.tradeName,
      'applicant': medicine.applicant,
      'generics': medicine.generics,
      'dosage_form': medicine.dosageForm,
      'price': medicine.price,
      'image': medicine.image,
    };
  }

  MostViewedMedicineEntity _mapRowToEntity(Map<String, dynamic> row) {
    return MostViewedMedicineEntity(
      id: row['id'] as int,
      name: row['name'] as String?,
      tradeName: row['trade_name'] as String?,
      applicant: row['applicant'] as String?,
      generics: row['generics'] as String?,
      dosageForm: row['dosage_form'] as String?,
      price: row['price'] as String?,
      image: row['image'] as String?,
    );
  }
}
