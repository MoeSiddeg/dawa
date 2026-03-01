class DoctorsResponse {
  final bool? status;
  final String? message;
  final DoctorsData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const DoctorsResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory DoctorsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? DoctorsData.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class DoctorsData {
  final List<DoctorData> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;

  const DoctorsData({this.data = const [], this.links, this.meta});

  factory DoctorsData.fromJson(Map<String, dynamic> json) {
    return DoctorsData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => DoctorData.fromJson(item as Map<String, dynamic>))
              .toList(growable: false) ??
          const [],
      links:
          json['links'] != null
              ? PaginationLinks.fromJson(json['links'] as Map<String, dynamic>)
              : null,
      meta:
          json['meta'] != null
              ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
              : null,
    );
  }
}

class DoctorData {
  final int id;
  final String? name;
  final String? alias;
  final int? governorateId;
  final String? jobTitle;
  final String? description;
  final DoctorUser? user;
  final String? phone;
  final String? mobile;

  const DoctorData({
    required this.id,
    this.name,
    this.alias,
    this.governorateId,
    this.jobTitle,
    this.description,
    this.user,
    this.phone,
    this.mobile,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      alias: json['alias']?.toString(),
      governorateId: _parseInt(json['governorate_id']),
      jobTitle: json['jop_title']?.toString(),
      description: json['description']?.toString(),
      user:
          json['user'] != null
              ? DoctorUser.fromJson(json['user'] as Map<String, dynamic>)
              : null,
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }
}

class DoctorUser {
  final int id;
  final String? name;
  final String? email;
  final String? type;

  const DoctorUser({required this.id, this.name, this.email, this.type});

  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    return DoctorUser(
      id: _parseInt(json['id']) ?? 0,
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
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  const PaginationMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: _parseInt(json['current_page']),
      from: _parseInt(json['from']),
      lastPage: _parseInt(json['last_page']),
      path: json['path']?.toString(),
      perPage: _parseInt(json['per_page']),
      to: _parseInt(json['to']),
      total: _parseInt(json['total']),
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
