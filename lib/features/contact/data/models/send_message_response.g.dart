// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );

Map<String, dynamic> _$SendMessageResponseToJson(
  SendMessageResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'errors': instance.errors,
  'custom': instance.custom,
};
