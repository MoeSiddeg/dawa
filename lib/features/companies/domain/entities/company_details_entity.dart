class CompanyDetailsEntity {
  final int id;
  final String name;
  final String? alias;
  final String? phone;
  final String? mobile;
  final String? fax;
  final String? address;
  final CompanyUserEntity? user;
  final String? responsableName;
  final String? responsableEmail;
  final String? logo;
  final String? banner;
  final int? countryId;
  final NameIdEntity? country;
  final int? governorateId;
  final NameIdEntity? governorate;
  final List<CompanySocialEntity> socials;
  final List<CompanyMedicineEntity> medicines;

  const CompanyDetailsEntity({
    required this.id,
    required this.name,
    this.alias,
    this.phone,
    this.mobile,
    this.fax,
    this.address,
    this.user,
    this.responsableName,
    this.responsableEmail,
    this.logo,
    this.banner,
    this.countryId,
    this.country,
    this.governorateId,
    this.governorate,
    this.socials = const [],
    this.medicines = const [],
  });
}

class CompanyUserEntity {
  final int id;
  final String? name;
  final String? email;
  final String? type;

  const CompanyUserEntity({required this.id, this.name, this.email, this.type});
}

class NameIdEntity {
  final int id;
  final String? name;

  const NameIdEntity({required this.id, this.name});
}

class CompanySocialEntity {
  final int id;
  final String? provider;
  final String? providerId;
  final String? url;
  final String? username;

  const CompanySocialEntity({
    required this.id,
    this.provider,
    this.providerId,
    this.url,
    this.username,
  });
}

class CompanyMedicineEntity {
  final int id;
  final String? nameAr;
  final String? nameEn;
  final String? alias;
  final int? medicineTypeId;
  final String? dosageForm;
  final int? shelfLife;
  final int? routeTypeId;
  final int? strength;
  final int? pharmacologicalGroupId;
  final String? price;
  final String? packUnitDetails;
  final String? indication;
  final String? packaging;
  final String? composition;
  final String? dosage;
  final String? registerNo;
  final String? registerDate;
  final String? expiryDate;
  final String? descriptionAr;
  final String? descriptionEn;
  final int? clientId;
  final int? companyId;
  final int? countryId;
  final int? countryIndustryId;
  final String? registerInfo;
  final int? statusId;
  final String? image;
  final int? viewsCount;

  const CompanyMedicineEntity({
    required this.id,
    this.nameAr,
    this.nameEn,
    this.alias,
    this.medicineTypeId,
    this.dosageForm,
    this.shelfLife,
    this.routeTypeId,
    this.strength,
    this.pharmacologicalGroupId,
    this.price,
    this.packUnitDetails,
    this.indication,
    this.packaging,
    this.composition,
    this.dosage,
    this.registerNo,
    this.registerDate,
    this.expiryDate,
    this.descriptionAr,
    this.descriptionEn,
    this.clientId,
    this.companyId,
    this.countryId,
    this.countryIndustryId,
    this.registerInfo,
    this.statusId,
    this.image,
    this.viewsCount,
  });
}
