import 'companies_response.dart';
import 'company_details_response.dart';

class CompanyMedicinesResponse {
  final bool? status;
  final String? message;
  final CompanyMedicinesData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const CompanyMedicinesResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory CompanyMedicinesResponse.fromJson(Map<String, dynamic> json) {
    return CompanyMedicinesResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : CompanyMedicinesData.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class CompanyMedicinesData {
  final List<CompanyMedicine> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;

  const CompanyMedicinesData({this.data = const [], this.links, this.meta});

  factory CompanyMedicinesData.fromJson(Map<String, dynamic> json) {
    return CompanyMedicinesData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    CompanyMedicine.fromJson(item as Map<String, dynamic>),
              )
              .toList(growable: false) ??
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
