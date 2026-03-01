class DoctorDetailsResponse {
  final bool? status;
  final String? message;
  final DoctorDetailsData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const DoctorDetailsResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory DoctorDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? DoctorDetailsData.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class DoctorDetailsData {
  final int id;
  final String? name;
  final String? alias;
  final int? governorateId;
  final Governorate? governorate;
  final String? jobTitle;
  final String? description;
  final DoctorDetailsUser? user;
  final String? phone;
  final String? mobile;
  final List<SocialLink> socials;

  const DoctorDetailsData({
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
  });

  factory DoctorDetailsData.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsData(
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
              ? DoctorDetailsUser.fromJson(json['user'] as Map<String, dynamic>)
              : null,
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
      socials:
          (json['socials'] as List<dynamic>?)
              ?.map((item) => SocialLink.fromJson(item as Map<String, dynamic>))
              .toList(growable: false) ??
          const [],
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

class DoctorDetailsUser {
  final int id;
  final String? name;
  final String? email;
  final String? type;

  const DoctorDetailsUser({required this.id, this.name, this.email, this.type});

  factory DoctorDetailsUser.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsUser(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

class SocialLink {
  final String? platform;
  final String? url;

  const SocialLink({this.platform, this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform']?.toString(),
      url: json['url']?.toString(),
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
