// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blogs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogsResponse _$BlogsResponseFromJson(Map<String, dynamic> json) =>
    BlogsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : BlogsDataWrapper.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );

Map<String, dynamic> _$BlogsResponseToJson(BlogsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
      'custom': instance.custom,
    };

BlogsDataWrapper _$BlogsDataWrapperFromJson(Map<String, dynamic> json) =>
    BlogsDataWrapper(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => BlogData.fromJson(e as Map<String, dynamic>))
              .toList(),
      links:
          json['links'] == null
              ? null
              : BlogLinks.fromJson(json['links'] as Map<String, dynamic>),
      meta:
          json['meta'] == null
              ? null
              : BlogMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogsDataWrapperToJson(BlogsDataWrapper instance) =>
    <String, dynamic>{
      'data': instance.data,
      'links': instance.links,
      'meta': instance.meta,
    };

BlogData _$BlogDataFromJson(Map<String, dynamic> json) => BlogData(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  alias: json['alias'] as String?,
  image: json['image'] as String?,
  description: json['description'] as String?,
  template: json['template'] as String?,
  images: BlogData._imagesFromJson(json['images']),
);

Map<String, dynamic> _$BlogDataToJson(BlogData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'alias': instance.alias,
  'image': instance.image,
  'description': instance.description,
  'template': instance.template,
  'images': BlogData._imagesToJson(instance.images),
};

BlogLinks _$BlogLinksFromJson(Map<String, dynamic> json) => BlogLinks(
  first: json['first'] as String?,
  last: json['last'] as String?,
  prev: json['prev'] as String?,
  next: json['next'] as String?,
);

Map<String, dynamic> _$BlogLinksToJson(BlogLinks instance) => <String, dynamic>{
  'first': instance.first,
  'last': instance.last,
  'prev': instance.prev,
  'next': instance.next,
};

BlogMeta _$BlogMetaFromJson(Map<String, dynamic> json) => BlogMeta(
  currentPage: (json['current_page'] as num?)?.toInt(),
  from: (json['from'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  links:
      (json['links'] as List<dynamic>?)
          ?.map((e) => BlogMetaLink.fromJson(e as Map<String, dynamic>))
          .toList(),
  path: json['path'] as String?,
  perPage: (json['per_page'] as num?)?.toInt(),
  to: (json['to'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$BlogMetaToJson(BlogMeta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'from': instance.from,
  'last_page': instance.lastPage,
  'links': instance.links,
  'path': instance.path,
  'per_page': instance.perPage,
  'to': instance.to,
  'total': instance.total,
};

BlogMetaLink _$BlogMetaLinkFromJson(Map<String, dynamic> json) => BlogMetaLink(
  url: json['url'] as String?,
  label: json['label'] as String?,
  active: json['active'] as bool?,
);

Map<String, dynamic> _$BlogMetaLinkToJson(BlogMetaLink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
