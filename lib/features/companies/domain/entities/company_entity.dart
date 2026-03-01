class CompanyEntity {
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
  final int? governorateId;

  const CompanyEntity({
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
    this.governorateId,
  });
}

class CompanyUserEntity {
  final int id;
  final String? name;
  final String? email;
  final String? type;

  const CompanyUserEntity({required this.id, this.name, this.email, this.type});
}
