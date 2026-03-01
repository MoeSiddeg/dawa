import 'doctor_categories_response.dart';

class DoctorsByCategoryResponse {
  final bool? status;
  final String? message;
  final DoctorsByCategoryData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const DoctorsByCategoryResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory DoctorsByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return DoctorsByCategoryResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? DoctorsByCategoryData.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class DoctorsByCategoryData {
  final DoctorCategory? category;
  final DoctorsPaginatedData? doctors;

  const DoctorsByCategoryData({this.category, this.doctors});

  factory DoctorsByCategoryData.fromJson(Map<String, dynamic> json) {
    return DoctorsByCategoryData(
      category:
          json['category'] != null
              ? DoctorCategory.fromJson(
                json['category'] as Map<String, dynamic>,
              )
              : null,
      doctors:
          json['doctors'] != null
              ? DoctorsPaginatedData.fromJson(
                json['doctors'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}

class DoctorsPaginatedData {
  final List<DoctorByCategoryData> data;

  const DoctorsPaginatedData({this.data = const []});

  factory DoctorsPaginatedData.fromJson(Map<String, dynamic> json) {
    return DoctorsPaginatedData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    DoctorByCategoryData.fromJson(item as Map<String, dynamic>),
              )
              .toList(growable: false) ??
          const [],
    );
  }
}

class DoctorByCategoryData {
  final int id;
  final String? name;
  final String? alias;
  final int? governorateId;
  final Governorate? governorate;
  final String? jobTitle;
  final String? description;
  final DoctorUser? user;
  final String? phone;
  final String? mobile;
  final List<SocialLink> socials;
  final DoctorCategory? category;

  const DoctorByCategoryData({
    required this.id,
    this.name,
    this.alias,
    this.governorateId,
    this.governorate,
    this.jobTitle,
    this.description,
    this.user,
    this.phone,
    this.mobile,
    this.socials = const [],
    this.category,
  });

  factory DoctorByCategoryData.fromJson(Map<String, dynamic> json) {
    return DoctorByCategoryData(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      alias: json['alias']?.toString(),
      governorateId: _parseInt(json['governorate_id']),
      governorate:
          json['governorate'] != null
              ? Governorate.fromJson(
                json['governorate'] as Map<String, dynamic>,
              )
              : null,
      jobTitle: json['jop_title']?.toString(),
      description: json['description']?.toString(),
      user:
          json['user'] != null
              ? DoctorUser.fromJson(json['user'] as Map<String, dynamic>)
              : null,
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
      socials:
          (json['socials'] as List<dynamic>?)
              ?.map((item) => SocialLink.fromJson(item as Map<String, dynamic>))
              .toList(growable: false) ??
          const [],
      category:
          json['category'] != null
              ? DoctorCategory.fromJson(
                json['category'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}

class Governorate {
  final int id;
  final String? name;

  const Governorate({required this.id, this.name});

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
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

class SocialLink {
  final int id;
  final String? provider;
  final String? providerId;
  final String? url;
  final String? username;

  const SocialLink({
    required this.id,
    this.provider,
    this.providerId,
    this.url,
    this.username,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: _parseInt(json['id']) ?? 0,
      provider: json['provider']?.toString(),
      providerId: json['provider_id']?.toString(),
      url: json['url']?.toString(),
      username: json['username']?.toString(),
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
