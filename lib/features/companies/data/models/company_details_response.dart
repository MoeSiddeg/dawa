class CompanyDetailsResponse {
  final bool? status;
  final String? message;
  final CompanyDetailsData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const CompanyDetailsResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory CompanyDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : CompanyDetailsData.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class CompanyDetailsData {
  final int id;
  final String name;
  final String? alias;
  final String? phone;
  final String? mobile;
  final String? fax;
  final String? address;
  final CompanyDetailsUser? user;
  final String? responsableName;
  final String? responsableEmail;
  final String? logo;
  final String? banner;
  final int? countryId;
  final CompanyDetailsCountry? country;
  final int? governorateId;
  final CompanyDetailsCountry? governorate;
  final List<CompanySocial> socials;
  final List<CompanyMedicine> medicines;

  CompanyDetailsData({
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
    List<CompanySocial>? socials,
    List<CompanyMedicine>? medicines,
  }) : socials = socials ?? const [],
       medicines = medicines ?? const [];

  factory CompanyDetailsData.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsData(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      alias: json['alias']?.toString(),
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
      fax: json['fax']?.toString(),
      address: json['address']?.toString(),
      user:
          json['user'] == null
              ? null
              : CompanyDetailsUser.fromJson(
                json['user'] as Map<String, dynamic>,
              ),
      responsableName: json['responsable_name']?.toString(),
      responsableEmail: json['responsable_email']?.toString(),
      logo: json['logo']?.toString(),
      banner: json['banner']?.toString(),
      countryId: _parseInt(json['country_id']),
      country:
          json['country'] == null
              ? null
              : CompanyDetailsCountry.fromJson(
                json['country'] as Map<String, dynamic>,
              ),
      governorateId: _parseInt(json['governorate_id']),
      governorate:
          json['governorate'] == null
              ? null
              : CompanyDetailsCountry.fromJson(
                json['governorate'] as Map<String, dynamic>,
              ),
      socials:
          (json['socials'] as List<dynamic>?)
              ?.map(
                (item) => CompanySocial.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      medicines:
          (json['medicines'] as List<dynamic>?)
              ?.map(
                (item) =>
                    CompanyMedicine.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}

class CompanyDetailsUser {
  final int id;
  final String? name;
  final String? email;
  final String? type;

  const CompanyDetailsUser({
    required this.id,
    this.name,
    this.email,
    this.type,
  });

  factory CompanyDetailsUser.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsUser(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

class CompanyDetailsCountry {
  final int id;
  final String? name;

  const CompanyDetailsCountry({required this.id, this.name});

  factory CompanyDetailsCountry.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsCountry(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
    );
  }
}

class CompanySocial {
  final int id;
  final String? provider;
  final String? providerId;
  final String? url;
  final String? username;

  const CompanySocial({
    required this.id,
    this.provider,
    this.providerId,
    this.url,
    this.username,
  });

  factory CompanySocial.fromJson(Map<String, dynamic> json) {
    return CompanySocial(
      id: _parseInt(json['id']) ?? 0,
      provider: json['provider']?.toString(),
      providerId: json['provider_id']?.toString(),
      url: json['url']?.toString(),
      username: json['username']?.toString(),
    );
  }
}

class CompanyMedicine {
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

  const CompanyMedicine({
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

  factory CompanyMedicine.fromJson(Map<String, dynamic> json) {
    return CompanyMedicine(
      id: _parseInt(json['id']) ?? 0,
      nameAr: json['name_ar']?.toString(),
      nameEn: json['name_en']?.toString(),
      alias: json['alias']?.toString(),
      medicineTypeId: _parseInt(json['medicine_type_id']),
      dosageForm: json['dosage_form']?.toString(),
      shelfLife: _parseInt(json['shelf_life']),
      routeTypeId: _parseInt(json['route_type_id']),
      strength: _parseInt(json['strength']),
      pharmacologicalGroupId: _parseInt(json['pharmacological_group_id']),
      price: json['price']?.toString(),
      packUnitDetails: json['pack_unit_details']?.toString(),
      indication: json['indication']?.toString(),
      packaging: json['packaging']?.toString(),
      composition: json['composition']?.toString(),
      dosage: json['dosage']?.toString(),
      registerNo: json['register_no']?.toString(),
      registerDate: json['register_date']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
      descriptionEn: json['description_en']?.toString(),
      clientId: _parseInt(json['client_id']),
      companyId: _parseInt(json['company_id']),
      countryId: _parseInt(json['country_id']),
      countryIndustryId: _parseInt(json['country_industry_id']),
      registerInfo: json['register_info']?.toString(),
      statusId: _parseInt(json['status_id']),
      image: json['image']?.toString(),
      viewsCount: _parseInt(json['views_count']),
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
