class UserProfileResponse {
  final bool? status;
  final String? message;
  final UserProfileData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const UserProfileResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? UserProfileData.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class UserProfileData {
  final int id;
  final String? name;
  final String? phone;
  final String? email;

  const UserProfileData({required this.id, this.name, this.phone, this.email});

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }
}
