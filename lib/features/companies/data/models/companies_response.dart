class CompaniesResponse {
  final bool? status;
  final String? message;
  final CompaniesData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const CompaniesResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory CompaniesResponse.fromJson(Map<String, dynamic> json) {
    return CompaniesResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : CompaniesData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class CompaniesData {
  final List<CompanyData> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;

  CompaniesData({List<CompanyData>? data, this.links, this.meta})
    : data = data ?? const [];

  factory CompaniesData.fromJson(Map<String, dynamic> json) {
    return CompaniesData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => CompanyData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      links:
          json['links'] == null
              ? null
              : PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
      meta:
          json['meta'] == null
              ? null
              : PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class CompanyData {
  final int id;
  final String name;
  final String? alias;
  final String? phone;
  final String? mobile;
  final String? fax;
  final String? address;
  final CompanyUser? user;
  final String? responsableName;
  final String? responsableEmail;
  final String? logo;
  final String? banner;
  final int? countryId;
  final int? governorateId;

  CompanyData({
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

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      id:
          json['id'] is int
              ? json['id'] as int
              : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      alias: json['alias']?.toString(),
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
      fax: json['fax']?.toString(),
      address: json['address']?.toString(),
      user:
          json['user'] == null
              ? null
              : CompanyUser.fromJson(json['user'] as Map<String, dynamic>),
      responsableName: json['responsable_name']?.toString(),
      responsableEmail: json['responsable_email']?.toString(),
      logo: json['logo']?.toString(),
      banner: json['banner']?.toString(),
      countryId:
          json['country_id'] is int
              ? json['country_id'] as int
              : int.tryParse('${json['country_id']}'),
      governorateId:
          json['governorate_id'] is int
              ? json['governorate_id'] as int
              : int.tryParse('${json['governorate_id']}'),
    );
  }
}

class CompanyUser {
  final int id;
  final String? name;
  final String? email;
  final String? type;

  CompanyUser({required this.id, this.name, this.email, this.type});

  factory CompanyUser.fromJson(Map<String, dynamic> json) {
    return CompanyUser(
      id:
          json['id'] is int
              ? json['id'] as int
              : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const PaginationLinks({this.first, this.last, this.prev, this.next});

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first']?.toString(),
      last: json['last']?.toString(),
      prev: json['prev']?.toString(),
      next: json['next']?.toString(),
    );
  }
}

class PaginationMeta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<PaginationMetaLink> links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  PaginationMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    List<PaginationMetaLink>? links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  }) : links = links ?? const [];

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: _parseInt(json['current_page']),
      from: _parseInt(json['from']),
      lastPage: _parseInt(json['last_page']),
      links:
          (json['links'] as List<dynamic>?)
              ?.map(
                (item) =>
                    PaginationMetaLink.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      path: json['path']?.toString(),
      perPage: _parseInt(json['per_page']),
      to: _parseInt(json['to']),
      total: _parseInt(json['total']),
    );
  }
}

class PaginationMetaLink {
  final String? url;
  final String? label;
  final bool? active;

  const PaginationMetaLink({this.url, this.label, this.active});

  factory PaginationMetaLink.fromJson(Map<String, dynamic> json) {
    return PaginationMetaLink(
      url: json['url']?.toString(),
      label: json['label']?.toString(),
      active: json['active'] as bool?,
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
