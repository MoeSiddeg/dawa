// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogDetailsResponse _$BlogDetailsResponseFromJson(Map<String, dynamic> json) =>
    BlogDetailsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : BlogData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );

Map<String, dynamic> _$BlogDetailsResponseToJson(
  BlogDetailsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'custom': instance.custom,
};
