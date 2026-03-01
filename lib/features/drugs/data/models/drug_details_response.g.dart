// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrugDetailsResponse _$DrugDetailsResponseFromJson(Map<String, dynamic> json) =>
    DrugDetailsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : DrugDetailsResponseData.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );

Map<String, dynamic> _$DrugDetailsResponseToJson(
  DrugDetailsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'custom': instance.custom,
};

DrugDetailsResponseData _$DrugDetailsResponseDataFromJson(
  Map<String, dynamic> json,
) => DrugDetailsResponseData(
  medicine:
      json['medicine'] == null
          ? null
          : DrugDetailsData.fromJson(json['medicine'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DrugDetailsResponseDataToJson(
  DrugDetailsResponseData instance,
) => <String, dynamic>{'medicine': instance.medicine};

DrugDetailsData _$DrugDetailsDataFromJson(Map<String, dynamic> json) =>
    DrugDetailsData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      alias: json['alias'] as String?,
      price: json['price'] as String?,
      image: json['image'] as String?,
      viewsCount: (json['views_count'] as num?)?.toInt(),
      status: json['status'] as bool?,
      tradeName: json['trade_name'] as String?,
      productType: json['product_type'] as String?,
      dosageForm: json['dosage_form'] as String?,
      shelfLife: json['shelf_life'] as String?,
      route: json['route'] as String?,
      strength: json['strength'] as String?,
      packUnit: json['pack_unit'] as String?,
      packDetails: json['pack_details'] as String?,
      companies:
          (json['companies'] as List<dynamic>?)
              ?.map((e) => CompanyData.fromJson(e as Map<String, dynamic>))
              .toList(),
      applicant: json['applicant'] as String?,
      registrationNo: json['registration_no'] as String?,
      registrationType: json['registration_type'] as String?,
      marketingType: json['marketing_type'] as String?,
      licenseStatus: json['license_status'] as String?,
      pricingStatus: json['pricing_status'] as String?,
      physicalCharacters: json['physical_characters'] as String?,
      storageConditions: json['storage_conditions'] as String?,
      registrationData: json['registration_data'] as String?,
      targetSpecies: json['target_species'] as String?,
      generics: json['generics'] as String?,
    );

Map<String, dynamic> _$DrugDetailsDataToJson(DrugDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'price': instance.price,
      'image': instance.image,
      'views_count': instance.viewsCount,
      'status': instance.status,
      'trade_name': instance.tradeName,
      'product_type': instance.productType,
      'dosage_form': instance.dosageForm,
      'shelf_life': instance.shelfLife,
      'route': instance.route,
      'strength': instance.strength,
      'pack_unit': instance.packUnit,
      'pack_details': instance.packDetails,
      'companies': instance.companies,
      'applicant': instance.applicant,
      'registration_no': instance.registrationNo,
      'registration_type': instance.registrationType,
      'marketing_type': instance.marketingType,
      'license_status': instance.licenseStatus,
      'pricing_status': instance.pricingStatus,
      'physical_characters': instance.physicalCharacters,
      'storage_conditions': instance.storageConditions,
      'registration_data': instance.registrationData,
      'target_species': instance.targetSpecies,
      'generics': instance.generics,
    };

CompanyData _$CompanyDataFromJson(Map<String, dynamic> json) => CompanyData(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  countryName: json['country_name'] as String?,
  companyMedicineRelation:
      json['company_medicine_relation'] == null
          ? null
          : CompanyMedicineRelation.fromJson(
            json['company_medicine_relation'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$CompanyDataToJson(CompanyData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country_name': instance.countryName,
      'company_medicine_relation': instance.companyMedicineRelation,
    };

CompanyMedicineRelation _$CompanyMedicineRelationFromJson(
  Map<String, dynamic> json,
) => CompanyMedicineRelation(
  id: json['id'] as String?,
  name:
      json['name'] == null
          ? null
          : RelationName.fromJson(json['name'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompanyMedicineRelationToJson(
  CompanyMedicineRelation instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

RelationName _$RelationNameFromJson(Map<String, dynamic> json) =>
    RelationName(ar: json['ar'] as String?, en: json['en'] as String?);

Map<String, dynamic> _$RelationNameToJson(RelationName instance) =>
    <String, dynamic>{'ar': instance.ar, 'en': instance.en};
