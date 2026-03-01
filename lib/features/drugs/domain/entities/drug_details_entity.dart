class DrugDetailsEntity {
  final int id;
  final String? name;
  final String? alias;
  final String? tradeName;
  final String? productType;
  final String? dosageForm;
  final String? shelfLife;
  final String? route;
  final String? strength;
  final String? packUnit;
  final String? packDetails;
  final String? price;
  final String? image;
  final int? viewsCount;
  final bool? status;
  final String? applicant;
  final String? registrationNo;
  final String? registrationType;
  final String? marketingType;
  final String? licenseStatus;
  final String? pricingStatus;
  final String? physicalCharacters;
  final String? storageConditions;
  final String? registrationData;
  final String? targetSpecies;
  final String? generics;
  final List<CompanyEntity>? companies;

  const DrugDetailsEntity({
    required this.id,
    this.name,
    this.alias,
    this.tradeName,
    this.productType,
    this.dosageForm,
    this.shelfLife,
    this.route,
    this.strength,
    this.packUnit,
    this.packDetails,
    this.price,
    this.image,
    this.viewsCount,
    this.status,
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
    this.companies,
  });
}

class CompanyEntity {
  final int? id;
  final String? name;
  final String? countryName;
  final CompanyMedicineRelationEntity? companyMedicineRelation;

  const CompanyEntity({
    this.id,
    this.name,
    this.countryName,
    this.companyMedicineRelation,
  });
}

class CompanyMedicineRelationEntity {
  final String? id;
  final RelationNameEntity? name;

  const CompanyMedicineRelationEntity({this.id, this.name});
}

class RelationNameEntity {
  final String? ar;
  final String? en;

  const RelationNameEntity({this.ar, this.en});
}
