import 'package:json_annotation/json_annotation.dart';

part 'drug_details_response.g.dart';

@JsonSerializable()
class DrugDetailsResponse {
  final bool? status;
  final String? message;
  final DrugDetailsResponseData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const DrugDetailsResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory DrugDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$DrugDetailsResponseFromJson(json);
}

@JsonSerializable()
class DrugDetailsResponseData {
  final DrugDetailsData? medicine;

  const DrugDetailsResponseData({this.medicine});

  factory DrugDetailsResponseData.fromJson(Map<String, dynamic> json) =>
      _$DrugDetailsResponseDataFromJson(json);
}

@JsonSerializable()
class DrugDetailsData {
  final int id;
  final String? name;
  final String? alias;
  final String? price;
  final String? image;
  @JsonKey(name: 'views_count')
  final int? viewsCount;
  final bool? status;
  @JsonKey(name: 'trade_name')
  final String? tradeName;
  @JsonKey(name: 'product_type')
  final String? productType;
  @JsonKey(name: 'dosage_form')
  final String? dosageForm;
  @JsonKey(name: 'shelf_life')
  final String? shelfLife;
  final String? route;
  final String? strength;
  @JsonKey(name: 'pack_unit')
  final String? packUnit;
  @JsonKey(name: 'pack_details')
  final String? packDetails;
  final List<CompanyData>? companies;
  final String? applicant;
  @JsonKey(name: 'registration_no')
  final String? registrationNo;
  @JsonKey(name: 'registration_type')
  final String? registrationType;
  @JsonKey(name: 'marketing_type')
  final String? marketingType;
  @JsonKey(name: 'license_status')
  final String? licenseStatus;
  @JsonKey(name: 'pricing_status')
  final String? pricingStatus;
  @JsonKey(name: 'physical_characters')
  final String? physicalCharacters;
  @JsonKey(name: 'storage_conditions')
  final String? storageConditions;
  @JsonKey(name: 'registration_data')
  final String? registrationData;
  @JsonKey(name: 'target_species')
  final String? targetSpecies;
  final String? generics;

  const DrugDetailsData({
    required this.id,
    this.name,
    this.alias,
    this.price,
    this.image,
    this.viewsCount,
    this.status,
    this.tradeName,
    this.productType,
    this.dosageForm,
    this.shelfLife,
    this.route,
    this.strength,
    this.packUnit,
    this.packDetails,
    this.companies,
    this.applicant,
    this.registrationNo,
    this.registrationType,
    this.marketingType,
    this.licenseStatus,
    this.pricingStatus,
    this.physicalCharacters,
    this.storageConditions,
    this.registrationData,
    this.targetSpecies,
    this.generics,
  });

  factory DrugDetailsData.fromJson(Map<String, dynamic> json) =>
      _$DrugDetailsDataFromJson(json);
}

@JsonSerializable()
class CompanyData {
  final int? id;
  final String? name;
  @JsonKey(name: 'country_name')
  final String? countryName;
  @JsonKey(name: 'company_medicine_relation')
  final CompanyMedicineRelation? companyMedicineRelation;

  const CompanyData({
    this.id,
    this.name,
    this.countryName,
    this.companyMedicineRelation,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) =>
      _$CompanyDataFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyDataToJson(this);
}

@JsonSerializable()
class CompanyMedicineRelation {
  final String? id;
  final RelationName? name;

  const CompanyMedicineRelation({this.id, this.name});

  factory CompanyMedicineRelation.fromJson(Map<String, dynamic> json) =>
      _$CompanyMedicineRelationFromJson(json);
}

@JsonSerializable()
class RelationName {
  final String? ar;
  final String? en;

  const RelationName({this.ar, this.en});

  factory RelationName.fromJson(Map<String, dynamic> json) =>
      _$RelationNameFromJson(json);
}
