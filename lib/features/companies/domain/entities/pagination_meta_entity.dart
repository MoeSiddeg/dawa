class PaginationMetaEntity {
  final int? currentPage;
  final int? lastPage;
  final int? total;

  const PaginationMetaEntity({this.currentPage, this.lastPage, this.total});

  PaginationMetaEntity copyWith({int? currentPage, int? lastPage, int? total}) {
    return PaginationMetaEntity(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }
}
