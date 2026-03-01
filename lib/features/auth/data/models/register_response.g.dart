// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] == null
              ? null
              : RegisterData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
      'custom': instance.custom,
    };

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) => RegisterData(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  accessToken: json['accessToken'] as String?,
  tokenType: json['tokenType'] as String?,
);

Map<String, dynamic> _$RegisterDataToJson(RegisterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
    };
