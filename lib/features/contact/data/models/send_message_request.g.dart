// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    SendMessageRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'message': instance.message,
    };
