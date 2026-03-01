class UpdateProfileResponse {
  final bool? status;
  final String? message;
  final dynamic data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const UpdateProfileResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}
