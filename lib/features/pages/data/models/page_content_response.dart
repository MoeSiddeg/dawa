class PageContentResponse {
  final bool? status;
  final String? message;
  final PageContentData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const PageContentResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory PageContentResponse.fromJson(Map<String, dynamic> json) {
    return PageContentResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? PageContentData.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class PageContentData {
  final int id;
  final String? name;
  final String? alias;
  final String? description;

  const PageContentData({
    required this.id,
    this.name,
    this.alias,
    this.description,
  });

  factory PageContentData.fromJson(Map<String, dynamic> json) {
    return PageContentData(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      alias: json['alias']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
