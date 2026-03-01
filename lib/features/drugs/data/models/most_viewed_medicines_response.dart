import 'package:json_annotation/json_annotation.dart';

part 'most_viewed_medicines_response.g.dart';

@JsonSerializable()
class MostViewedMedicinesResponse {
  final bool? status;
  final String? message;
  final MostViewedMedicinesData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  const MostViewedMedicinesResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory MostViewedMedicinesResponse.fromJson(Map<String, dynamic> json) =>
      _$MostViewedMedicinesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MostViewedMedicinesResponseToJson(this);
}

@JsonSerializable()
class MostViewedMedicinesData {
  final List<MostViewedMedicineData> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;

  const MostViewedMedicinesData({this.data = const [], this.links, this.meta});

  factory MostViewedMedicinesData.fromJson(Map<String, dynamic> json) =>
      _$MostViewedMedicinesDataFromJson(json);

  Map<String, dynamic> toJson() => _$MostViewedMedicinesDataToJson(this);
}

@JsonSerializable()
class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const PaginationLinks({this.first, this.last, this.prev, this.next});

  factory PaginationLinks.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinksFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationLinksToJson(this);
}

@JsonSerializable()
class PaginationMeta {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  final int? from;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  final String? path;
  @JsonKey(name: 'per_page')
  final int? perPage;
  final int? to;
  final int? total;
  final List<PaginationLink>? links;

  const PaginationMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
    this.links,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

@JsonSerializable()
class MostViewedMedicineData {
  final int id;
  final String? name;
  final String? alias;
  @JsonKey(name: 'registration_no')
  final String? registrationNo;
  @JsonKey(name: 'trade_name')
  final String? tradeName;
  final String? applicant;
  final String? generics;
  final String? price;
  final String? image;
  @JsonKey(name: 'is_favorited')
  final bool? isFavorited;
  @JsonKey(name: 'dosage_form')
  final String? dosageForm;

  const MostViewedMedicineData({
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

  factory MostViewedMedicineData.fromJson(Map<String, dynamic> json) =>
      _$MostViewedMedicineDataFromJson(json);

  Map<String, dynamic> toJson() => _$MostViewedMedicineDataToJson(this);
}

@JsonSerializable()
class PaginationLink {
  final String? url;
  final String? label;
  final bool? active;

  const PaginationLink({this.url, this.label, this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationLinkToJson(this);
}
