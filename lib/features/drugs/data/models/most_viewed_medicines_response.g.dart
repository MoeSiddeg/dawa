// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'most_viewed_medicines_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MostViewedMedicinesResponse _$MostViewedMedicinesResponseFromJson(
  Map<String, dynamic> json,
) => MostViewedMedicinesResponse(
  status: json['status'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : MostViewedMedicinesData.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
  errors: json['errors'] as List<dynamic>?,
  custom: json['custom'] as List<dynamic>?,
);

Map<String, dynamic> _$MostViewedMedicinesResponseToJson(
  MostViewedMedicinesResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'custom': instance.custom,
};

MostViewedMedicinesData _$MostViewedMedicinesDataFromJson(
  Map<String, dynamic> json,
) => MostViewedMedicinesData(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => MostViewedMedicineData.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
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

Map<String, dynamic> _$MostViewedMedicinesDataToJson(
  MostViewedMedicinesData instance,
) => <String, dynamic>{
  'data': instance.data,
  'links': instance.links,
  'meta': instance.meta,
};

PaginationLinks _$PaginationLinksFromJson(Map<String, dynamic> json) =>
    PaginationLinks(
      first: json['first'] as String?,
      last: json['last'] as String?,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );

Map<String, dynamic> _$PaginationLinksToJson(PaginationLinks instance) =>
    <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      currentPage: (json['current_page'] as num?)?.toInt(),
      from: (json['from'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      path: json['path'] as String?,
      perPage: (json['per_page'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      links:
          (json['links'] as List<dynamic>?)
              ?.map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'path': instance.path,
      'per_page': instance.perPage,
      'to': instance.to,
      'total': instance.total,
      'links': instance.links,
    };

MostViewedMedicineData _$MostViewedMedicineDataFromJson(
  Map<String, dynamic> json,
) => MostViewedMedicineData(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  alias: json['alias'] as String?,
  registrationNo: json['registration_no'] as String?,
  tradeName: json['trade_name'] as String?,
  applicant: json['applicant'] as String?,
  generics: json['generics'] as String?,
  price: json['price'] as String?,
  image: json['image'] as String?,
  isFavorited: json['is_favorited'] as bool?,
  dosageForm: json['dosage_form'] as String?,
);

Map<String, dynamic> _$MostViewedMedicineDataToJson(
  MostViewedMedicineData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'alias': instance.alias,
  'registration_no': instance.registrationNo,
  'trade_name': instance.tradeName,
  'applicant': instance.applicant,
  'generics': instance.generics,
  'price': instance.price,
  'image': instance.image,
  'is_favorited': instance.isFavorited,
  'dosage_form': instance.dosageForm,
};

PaginationLink _$PaginationLinkFromJson(Map<String, dynamic> json) =>
    PaginationLink(
      url: json['url'] as String?,
      label: json['label'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$PaginationLinkToJson(PaginationLink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
