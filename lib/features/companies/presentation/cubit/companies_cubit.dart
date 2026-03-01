import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/companies_response.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/pagination_meta_entity.dart';
import '../../domain/repositories/companies_repository.dart';
import 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final CompaniesRepository _repository;
  final List<CompanyEntity> _cachedCompanies = [];
  PaginationMetaEntity? _meta;
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;
  Future<void>? _loadFuture;

  CompaniesCubit(this._repository) : super(const CompaniesInitial());

  Future<void> loadCompanies({int page = 1}) {
    if (_loadFuture != null) {
      return _loadFuture!;
    }

    final currentPage = _meta?.currentPage ?? 0;
    if (page <= currentPage && _cachedCompanies.isNotEmpty) {
      emit(
        CompaniesSuccess(
          companies: List.unmodifiable(_cachedCompanies),
          meta: _meta,
        ),
      );
      return Future.value();
    }

    final isInitialLoad = page == 1 && _cachedCompanies.isEmpty;
    final isPaginating = page > 1;

    if (isPaginating) {
      if (_hasReachedEnd || _isLoadingMore) {
        return Future.value();
      }
      _isLoadingMore = true;
      emit(
        CompaniesSuccess(
          companies: List.unmodifiable(_cachedCompanies),
          meta: _meta,
          isLoadingMore: true,
        ),
      );
    } else if (!isInitialLoad) {
      emit(
        CompaniesSuccess(
          companies: List.unmodifiable(_cachedCompanies),
          meta: _meta,
        ),
      );
    } else {
      emit(const CompaniesLoading());
    }

    _loadFuture = _fetchCompanies(page: page, append: isPaginating);
    return _loadFuture!;
  }

  List<CompanyEntity> getCompanies({int? limit}) {
    if (_cachedCompanies.isEmpty) {
      return const [];
    }
    if (limit == null || limit >= _cachedCompanies.length) {
      return List.unmodifiable(_cachedCompanies);
    }
    return List.unmodifiable(_cachedCompanies.take(limit));
  }

  Future<void> refreshCompanies({int page = 1}) {
    _cachedCompanies.clear();
    _meta = null;
    _hasReachedEnd = false;
    _isLoadingMore = false;
    return loadCompanies(page: page);
  }

  Future<void> _fetchCompanies({
    required int page,
    required bool append,
  }) async {
    final result = await _repository.getCompanies(page: page);

    result.when(
      success: (response) {
        final mapped = _mapToEntities(response);
        if (append) {
          if (mapped.companies.isEmpty) {
            _hasReachedEnd = true;
          } else {
            _cachedCompanies.addAll(mapped.companies);
            _meta =
                mapped.meta?.copyWith(currentPage: page) ??
                PaginationMetaEntity(currentPage: page);
            if (mapped.meta?.lastPage != null &&
                page >= mapped.meta!.lastPage!) {
              _hasReachedEnd = true;
            }
          }
        } else {
          _cachedCompanies
            ..clear()
            ..addAll(mapped.companies);
          _meta = mapped.meta;
          _hasReachedEnd =
              mapped.meta?.lastPage != null && mapped.meta!.lastPage! <= page;
        }
        _isLoadingMore = false;

        if (_cachedCompanies.isEmpty) {
          emit(const CompaniesEmpty());
        } else {
          emit(
            CompaniesSuccess(
              companies: List.unmodifiable(_cachedCompanies),
              meta: _meta,
              isLoadingMore: _isLoadingMore,
            ),
          );
        }
      },
      failure: (error) {
        _isLoadingMore = false;
        emit(CompaniesError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _loadFuture = null;
  }

  _CompanyMappingResult _mapToEntities(CompaniesResponse response) {
    final data = response.data;
    if (data == null) {
      return const _CompanyMappingResult(companies: []);
    }

    final companies = data.data
        .map(
          (company) => CompanyEntity(
            id: company.id,
            name: company.name,
            alias: company.alias,
            phone: company.phone,
            mobile: company.mobile,
            fax: company.fax,
            address: company.address,
            user:
                company.user == null
                    ? null
                    : CompanyUserEntity(
                      id: company.user!.id,
                      name: company.user!.name,
                      email: company.user!.email,
                      type: company.user!.type,
                    ),
            responsableName: company.responsableName,
            responsableEmail: company.responsableEmail,
            logo: company.logo,
            banner: company.banner,
            countryId: company.countryId,
            governorateId: company.governorateId,
          ),
        )
        .where((company) => company.logo != null && company.logo!.isNotEmpty)
        .toList(growable: false);

    final meta =
        data.meta == null
            ? null
            : PaginationMetaEntity(
              currentPage: data.meta!.currentPage,
              lastPage: data.meta!.lastPage,
              total: data.meta!.total,
            );

    return _CompanyMappingResult(companies: companies, meta: meta);
  }

  int get currentPage => _meta?.currentPage ?? 0;
  bool get hasReachedEnd => _hasReachedEnd;
  bool get isLoadingMore => _isLoadingMore;
}

class _CompanyMappingResult {
  final List<CompanyEntity> companies;
  final PaginationMetaEntity? meta;

  const _CompanyMappingResult({required this.companies, this.meta});
}
