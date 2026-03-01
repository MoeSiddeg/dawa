import '../../domain/entities/company_details_entity.dart';
import '../../domain/entities/pagination_meta_entity.dart';

sealed class CompanyDetailsState {
  const CompanyDetailsState();
}

class CompanyDetailsInitial extends CompanyDetailsState {
  const CompanyDetailsInitial();
}

class CompanyDetailsLoading extends CompanyDetailsState {
  const CompanyDetailsLoading();
}

class CompanyDetailsSuccess extends CompanyDetailsState {
  final CompanyDetailsEntity company;
  final List<CompanyMedicineEntity> medicines;
  final PaginationMetaEntity? meta;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? paginationError;

  const CompanyDetailsSuccess({
    required this.company,
    this.medicines = const [],
    this.meta,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.paginationError,
  });
}

class CompanyDetailsError extends CompanyDetailsState {
  final String message;
  const CompanyDetailsError(this.message);
}
