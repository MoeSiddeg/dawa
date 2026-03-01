import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/company_details_response.dart';
import '../../data/models/company_medicines_response.dart';
import '../../domain/entities/company_details_entity.dart';
import '../../domain/entities/pagination_meta_entity.dart';
import '../../domain/repositories/companies_repository.dart';
import 'company_details_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  final CompaniesRepository _repository;
  final Map<int, CompanyDetailsEntity> _companyCache = {};
  final Map<int, List<CompanyMedicineEntity>> _medicinesCache = {};
  final Map<int, PaginationMetaEntity?> _metaCache = {};
  final Map<int, bool> _hasReachedEndCache = {};
  final Map<int, bool> _isLoadingMoreCache = {};
  final Map<int, String?> _paginationErrors = {};
  final Map<int, Future<void>> _ongoingRequests = {};
  final Map<int, Future<void>> _ongoingMedicinesRequests = {};

  CompanyDetailsCubit(this._repository) : super(const CompanyDetailsInitial());

  Future<void> loadCompany(int id) {
    if (_companyCache.containsKey(id) && _medicinesCache.containsKey(id)) {
      _emitFromCache(id);
      return Future.value();
    }

    if (_ongoingRequests.containsKey(id)) {
      return _ongoingRequests[id]!;
    }

    final future = _fetchCompany(id);
    _ongoingRequests[id] = future;
    return future;
  }

  Future<void> refreshCompany(int id) {
    _companyCache.remove(id);
    _medicinesCache.remove(id);
    _metaCache.remove(id);
    _hasReachedEndCache.remove(id);
    _isLoadingMoreCache.remove(id);
    _paginationErrors.remove(id);
    _ongoingRequests.remove(id);
    _ongoingMedicinesRequests.remove(id);
    return loadCompany(id);
  }

  Future<void> loadMoreMedicines(int id) {
    if (!_companyCache.containsKey(id)) {
      return Future.value();
    }

    if (_hasReachedEndCache[id] == true) {
      return Future.value();
    }

    if (_isLoadingMoreCache[id] == true) {
      return Future.value();
    }

    final nextPage = (_metaCache[id]?.currentPage ?? 1) + 1;
    _isLoadingMoreCache[id] = true;
    _emitFromCache(id, overrideLoadingMore: true);
    return _fetchMedicines(companyId: id, page: nextPage, append: true);
  }

  Future<void> _fetchCompany(int id) async {
    emit(const CompanyDetailsLoading());

    final result = await _repository.getCompanyDetails(id);

    await result.when(
      success: (response) async {
        if (response.data == null) {
          emit(const CompanyDetailsError('لا توجد بيانات عن الشركة'));
          return;
        }

        final entity = _mapToEntity(response.data!);
        _companyCache[id] = entity;
        _medicinesCache[id] = [];
        _metaCache[id] = null;
        _hasReachedEndCache[id] = false;
        _isLoadingMoreCache[id] = false;
        _paginationErrors[id] = null;

        await _fetchMedicines(companyId: id, page: 1, append: false);
        _emitFromCache(id);
      },
      failure: (error) {
        emit(CompanyDetailsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _ongoingRequests.remove(id);
  }

  Future<void> _fetchMedicines({
    required int companyId,
    required int page,
    required bool append,
  }) {
    if (_ongoingMedicinesRequests.containsKey(companyId)) {
      return _ongoingMedicinesRequests[companyId]!;
    }

    final future = _performFetchMedicines(
      companyId: companyId,
      page: page,
      append: append,
    );
    _ongoingMedicinesRequests[companyId] = future;
    return future;
  }

  Future<void> _performFetchMedicines({
    required int companyId,
    required int page,
    required bool append,
  }) async {
    final result = await _repository.getCompanyMedicines(
      companyId: companyId,
      page: page,
    );

    result.when(
      success: (response) {
        final mapped = _mapMedicinesResponse(response);
        final existing = _medicinesCache[companyId] ?? [];
        final combined =
            append ? [...existing, ...mapped.medicines] : mapped.medicines;
        _medicinesCache[companyId] = combined;

        final meta =
            mapped.meta?.copyWith(currentPage: page) ??
            PaginationMetaEntity(
              currentPage: page,
              lastPage: null,
              total: mapped.medicines.length,
            );
        _metaCache[companyId] = meta;

        final lastPage = meta.lastPage;
        final hasReachedEnd =
            (lastPage != null && page >= lastPage) || mapped.medicines.isEmpty;
        _hasReachedEndCache[companyId] = hasReachedEnd;
        _isLoadingMoreCache[companyId] = false;
        _paginationErrors[companyId] = null;
        _emitFromCache(companyId);
      },
      failure: (error) {
        _isLoadingMoreCache[companyId] = false;
        _paginationErrors[companyId] =
            error.apiErrorModel.message ?? 'حدث خطأ ما';
        _emitFromCache(companyId);
      },
    );

    _ongoingMedicinesRequests.remove(companyId);
  }

  void _emitFromCache(int companyId, {bool? overrideLoadingMore}) {
    final company = _companyCache[companyId];
    if (company == null) return;

    emit(
      CompanyDetailsSuccess(
        company: company,
        medicines: List.unmodifiable(_medicinesCache[companyId] ?? const []),
        meta: _metaCache[companyId],
        isLoadingMore:
            overrideLoadingMore ?? (_isLoadingMoreCache[companyId] ?? false),
        hasReachedEnd: _hasReachedEndCache[companyId] ?? false,
        paginationError: _paginationErrors[companyId],
      ),
    );
  }

  CompanyDetailsEntity _mapToEntity(CompanyDetailsData data) {
    return CompanyDetailsEntity(
      id: data.id,
      name: data.name,
      alias: data.alias,
      phone: data.phone,
      mobile: data.mobile,
      fax: data.fax,
      address: data.address,
      user:
          data.user == null
              ? null
              : CompanyUserEntity(
                id: data.user!.id,
                name: data.user!.name,
                email: data.user!.email,
                type: data.user!.type,
              ),
      responsableName: data.responsableName,
      responsableEmail: data.responsableEmail,
      logo: data.logo,
      banner: data.banner,
      countryId: data.countryId,
      country:
          data.country == null
              ? null
              : NameIdEntity(id: data.country!.id, name: data.country!.name),
      governorateId: data.governorateId,
      governorate:
          data.governorate == null
              ? null
              : NameIdEntity(
                id: data.governorate!.id,
                name: data.governorate!.name,
              ),
      socials: data.socials
          .map(
            (social) => CompanySocialEntity(
              id: social.id,
              provider: social.provider,
              providerId: social.providerId,
              url: social.url,
              username: social.username,
            ),
          )
          .toList(growable: false),
      medicines: const [],
    );
  }

  _MedicinesMappingResult _mapMedicinesResponse(
    CompanyMedicinesResponse response,
  ) {
    final data = response.data;
    if (data == null) {
      return const _MedicinesMappingResult(medicines: []);
    }

    final medicines = data.data.map(_mapMedicine).toList(growable: false);

    final meta =
        data.meta == null
            ? null
            : PaginationMetaEntity(
              currentPage: data.meta!.currentPage,
              lastPage: data.meta!.lastPage,
              total: data.meta!.total,
            );

    return _MedicinesMappingResult(medicines: medicines, meta: meta);
  }

  CompanyMedicineEntity _mapMedicine(CompanyMedicine medicine) {
    return CompanyMedicineEntity(
      id: medicine.id,
      nameAr: medicine.nameAr,
      nameEn: medicine.nameEn,
      alias: medicine.alias,
      medicineTypeId: medicine.medicineTypeId,
      dosageForm: medicine.dosageForm,
      shelfLife: medicine.shelfLife,
      routeTypeId: medicine.routeTypeId,
      strength: medicine.strength,
      pharmacologicalGroupId: medicine.pharmacologicalGroupId,
      price: medicine.price,
      packUnitDetails: medicine.packUnitDetails,
      indication: medicine.indication,
      packaging: medicine.packaging,
      composition: medicine.composition,
      dosage: medicine.dosage,
      registerNo: medicine.registerNo,
      registerDate: medicine.registerDate,
      expiryDate: medicine.expiryDate,
      descriptionAr: medicine.descriptionAr,
      descriptionEn: medicine.descriptionEn,
      clientId: medicine.clientId,
      companyId: medicine.companyId,
      countryId: medicine.countryId,
      countryIndustryId: medicine.countryIndustryId,
      registerInfo: medicine.registerInfo,
      statusId: medicine.statusId,
      image: medicine.image,
      viewsCount: medicine.viewsCount,
    );
  }
}

class _MedicinesMappingResult {
  final List<CompanyMedicineEntity> medicines;
  final PaginationMetaEntity? meta;

  const _MedicinesMappingResult({required this.medicines, this.meta});
}
