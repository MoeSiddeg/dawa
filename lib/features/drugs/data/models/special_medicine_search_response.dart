class SpecialMedicineSearchResponse {
  final bool? status;
  final String? message;
  final SpecialMedicineSearchData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const SpecialMedicineSearchResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory SpecialMedicineSearchResponse.fromJson(Map<String, dynamic> json) {
    return SpecialMedicineSearchResponse(
      status: json['status'] as bool?,
      message: json['message']?.toString(),
      data:
          json['data'] != null
              ? SpecialMedicineSearchData.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }
}

class SpecialMedicineSearchData {
  final List<SpecialMedicineItem> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;

  const SpecialMedicineSearchData({required this.data, this.links, this.meta});

  factory SpecialMedicineSearchData.fromJson(Map<String, dynamic> json) {
    return SpecialMedicineSearchData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => SpecialMedicineItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
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

class SpecialMedicineItem {
  final int id;
  final String? name;
  final String? alias;
  final String? registrationNo;
  final String? tradeName;
  final String? applicant;
  final String? generics;
  final String? price;
  final String? image;
  final bool? isFavorited;
  final String? dosageForm;

  const SpecialMedicineItem({
    required this.id,
    this.name,
    this.alias,
    this.registrationNo,
    this.tradeName,
    this.applicant,
    this.generics,
    this.price,
    this.image,
    this.isFavorited,
    this.dosageForm,
  });

  factory SpecialMedicineItem.fromJson(Map<String, dynamic> json) {
    return SpecialMedicineItem(
      id: _parseInt(json['id']) ?? 0,
      name: json['name']?.toString(),
      alias: json['alias']?.toString(),
      registrationNo: json['registration_no']?.toString(),
      tradeName: json['trade_name']?.toString(),
      applicant: json['applicant']?.toString(),
      generics: json['generics']?.toString(),
      price: json['price']?.toString(),
      image: json['image']?.toString(),
      isFavorited: json['is_favorited'] as bool?,
      dosageForm: json['dosage_form']?.toString(),
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
  if (value is String) return int.tryParse(value);
  return null;
}
