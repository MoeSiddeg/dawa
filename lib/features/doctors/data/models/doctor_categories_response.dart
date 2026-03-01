class DoctorCategoriesResponse {
  final bool? status;
  final String? message;
  final DoctorCategoriesData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const DoctorCategoriesResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory DoctorCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return DoctorCategoriesResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? DoctorCategoriesData.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class DoctorCategoriesData {
  final List<DoctorCategory> data;

  const DoctorCategoriesData({this.data = const []});

  factory DoctorCategoriesData.fromJson(Map<String, dynamic> json) {
    return DoctorCategoriesData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => DoctorCategory.fromJson(item as Map<String, dynamic>),
              )
              .toList(growable: false) ??
          const [],
    );
  }
}

class DoctorCategory {
  final int id;
  final String? name;
  final String? alias;

  const DoctorCategory({required this.id, this.name, this.alias});

  factory DoctorCategory.fromJson(Map<String, dynamic> json) {
    return DoctorCategory(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      alias: json['alias']?.toString(),
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
