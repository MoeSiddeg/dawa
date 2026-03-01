import '../../domain/entities/company_entity.dart';
import '../../domain/entities/pagination_meta_entity.dart';

sealed class CompaniesState {
  const CompaniesState();
}

class CompaniesInitial extends CompaniesState {
  const CompaniesInitial();
}

class CompaniesLoading extends CompaniesState {
  const CompaniesLoading();
}

class CompaniesSuccess extends CompaniesState {
  final List<CompanyEntity> companies;
  final PaginationMetaEntity? meta;
  final bool isLoadingMore;

  const CompaniesSuccess({
    required this.companies,
    this.meta,
    this.isLoadingMore = false,
  });
}

class CompaniesEmpty extends CompaniesState {
  const CompaniesEmpty();
}

class CompaniesError extends CompaniesState {
  final String message;
  final PaginationMetaEntity? meta;
  const CompaniesError(this.message, {this.meta});
}
