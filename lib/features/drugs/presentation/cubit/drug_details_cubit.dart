import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/drug_details_response.dart';
import '../../domain/entities/drug_details_entity.dart';
import '../../domain/repositories/drug_details_repository.dart';
import 'drug_details_state.dart';

class DrugDetailsCubit extends Cubit<DrugDetailsState> {
  final DrugDetailsRepository _repository;

  DrugDetailsCubit(this._repository) : super(const DrugDetailsInitial());

  Future<void> loadDrugDetails(int id) async {
    emit(const DrugDetailsLoading());

    final result = await _repository.getDrugDetails(id);

    result.when(
      success: (response) {
        if (response.data?.medicine != null) {
          final entity = _mapToEntity(response.data!.medicine!);
          emit(DrugDetailsSuccess(entity));
        } else {
          emit(const DrugDetailsError('لم يتم العثور على بيانات الدواء'));
        }
      },
      failure: (error) {
        emit(DrugDetailsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  DrugDetailsEntity _mapToEntity(DrugDetailsData data) {
    return DrugDetailsEntity(
      id: data.id,
      name: data.name,
      alias: data.alias,
      tradeName: data.tradeName,
      productType: data.productType,
      dosageForm: data.dosageForm,
      shelfLife: data.shelfLife,
      route: data.route,
      strength: data.strength,
      packUnit: data.packUnit,
      packDetails: data.packDetails,
      price: data.price,
      image: data.image,
      viewsCount: data.viewsCount,
      status: data.status,
      applicant: data.applicant,
      registrationNo: data.registrationNo,
      registrationType: data.registrationType,
      marketingType: data.marketingType,
      licenseStatus: data.licenseStatus,
      pricingStatus: data.pricingStatus,
      physicalCharacters: data.physicalCharacters,
      storageConditions: data.storageConditions,
      registrationData: data.registrationData,
      targetSpecies: data.targetSpecies,
      generics: data.generics,
      companies:
          data.companies?.map((c) {
            // Debug print to see what we're getting
            print('Company data: ${c.toJson()}');
            print('Company name: ${c.name}');
            return CompanyEntity(
              id: c.id,
              name: c.name,
              countryName: c.countryName,
              companyMedicineRelation:
                  c.companyMedicineRelation != null
                      ? CompanyMedicineRelationEntity(
                        id: c.companyMedicineRelation!.id,
                        name:
                            c.companyMedicineRelation!.name != null
                                ? RelationNameEntity(
                                  ar: c.companyMedicineRelation!.name!.ar,
                                  en: c.companyMedicineRelation!.name!.en,
                                )
                                : null,
                      )
                      : null,
            );
          }).toList(),
    );
  }
}
