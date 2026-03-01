import '../../domain/entities/special_medicine_entity.dart';

sealed class SpecialMedicineSearchState {
  const SpecialMedicineSearchState();
}

class SpecialMedicineSearchInitial extends SpecialMedicineSearchState {
  const SpecialMedicineSearchInitial();
}

class SpecialMedicineSearchLoading extends SpecialMedicineSearchState {
  const SpecialMedicineSearchLoading();
}

class SpecialMedicineSearchLoadingMore extends SpecialMedicineSearchState {
  final List<SpecialMedicineEntity> medicines;
  final int currentPage;
  final int totalPages;

  const SpecialMedicineSearchLoadingMore({
    required this.medicines,
    required this.currentPage,
    required this.totalPages,
  });
}

class SpecialMedicineSearchSuccess extends SpecialMedicineSearchState {
  final List<SpecialMedicineEntity> medicines;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;

  const SpecialMedicineSearchSuccess({
    required this.medicines,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasMore,
  });
}

class SpecialMedicineSearchError extends SpecialMedicineSearchState {
  final String message;

  const SpecialMedicineSearchError(this.message);
}

class SpecialMedicineSearchEmpty extends SpecialMedicineSearchState {
  const SpecialMedicineSearchEmpty();
}
