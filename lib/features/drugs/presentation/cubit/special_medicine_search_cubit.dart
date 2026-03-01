import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/special_medicine_search_response.dart';
import '../../domain/entities/special_medicine_entity.dart';
import '../../domain/repositories/special_medicine_search_repository.dart';
import 'special_medicine_search_state.dart';

class SpecialMedicineSearchCubit extends Cubit<SpecialMedicineSearchState> {
  final SpecialMedicineSearchRepository _repository;

  SpecialMedicineSearchCubit(this._repository)
    : super(const SpecialMedicineSearchInitial());

  String? _tradeName;
  String? _genericName;
  String? _dosageForm;
  String? _registerNo;
  String? _applicantName;
  String? _pharmacologicalGroup;
  String? _targetSpecies;
  int _currentPage = 1;
  int _totalPages = 1;
  List<SpecialMedicineEntity> _medicines = [];

  Future<void> search({
    String? tradeName,
    String? genericName,
    String? dosageForm,
    String? registerNo,
    String? applicantName,
    String? pharmacologicalGroup,
    String? targetSpecies,
  }) async {
    _tradeName = tradeName;
    _genericName = genericName;
    _dosageForm = dosageForm;
    _registerNo = registerNo;
    _applicantName = applicantName;
    _pharmacologicalGroup = pharmacologicalGroup;
    _targetSpecies = targetSpecies;
    _currentPage = 1;
    _medicines = [];

    emit(const SpecialMedicineSearchLoading());

    await _fetchMedicines();
  }

  Future<void> loadMore() async {
    if (state is SpecialMedicineSearchLoadingMore) return;
    if (_currentPage >= _totalPages) return;

    final currentState = state;
    if (currentState is SpecialMedicineSearchSuccess) {
      emit(
        SpecialMedicineSearchLoadingMore(
          medicines: currentState.medicines,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
        ),
      );

      _currentPage++;
      await _fetchMedicines(isLoadMore: true);
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _medicines = [];
    emit(const SpecialMedicineSearchLoading());
    await _fetchMedicines();
  }

  Future<void> _fetchMedicines({bool isLoadMore = false}) async {
    final result = await _repository.searchMedicines(
      tradeName: _tradeName,
      genericName: _genericName,
      dosageForm: _dosageForm,
      registerNo: _registerNo,
      applicantName: _applicantName,
      pharmacologicalGroup: _pharmacologicalGroup,
      targetSpecies: _targetSpecies,
      page: _currentPage,
    );

    result.when(
      success: (response) {
        final newMedicines = _mapToEntities(response.data?.data ?? []);

        if (isLoadMore) {
          _medicines = [..._medicines, ...newMedicines];
        } else {
          _medicines = newMedicines;
        }

        _totalPages = response.data?.meta?.lastPage ?? 1;
        final totalItems = response.data?.meta?.total ?? 0;

        if (_medicines.isEmpty) {
          emit(const SpecialMedicineSearchEmpty());
        } else {
          emit(
            SpecialMedicineSearchSuccess(
              medicines: _medicines,
              currentPage: _currentPage,
              totalPages: _totalPages,
              totalItems: totalItems,
              hasMore: _currentPage < _totalPages,
            ),
          );
        }
      },
      failure: (error) {
        emit(
          SpecialMedicineSearchError(
            error.apiErrorModel.message ?? 'حدث خطأ أثناء البحث',
          ),
        );
      },
    );
  }

  List<SpecialMedicineEntity> _mapToEntities(List<SpecialMedicineItem> items) {
    return items
        .map(
          (item) => SpecialMedicineEntity(
            id: item.id,
            name: item.name,
            alias: item.alias,
            registrationNo: item.registrationNo,
            tradeName: item.tradeName,
            applicant: item.applicant,
            generics: item.generics,
            price: item.price,
            image: item.image,
            isFavorited: item.isFavorited,
            dosageForm: item.dosageForm,
          ),
        )
        .toList();
  }
}
