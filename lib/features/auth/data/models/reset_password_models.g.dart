// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequest _$SendOtpRequestFromJson(Map<String, dynamic> json) =>
    SendOtpRequest(email: json['email'] as String);

Map<String, dynamic> _$SendOtpRequestToJson(SendOtpRequest instance) =>
    <String, dynamic>{'email': instance.email};

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{'email': instance.email, 'otp': instance.otp};

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};

ResetPasswordResponse _$ResetPasswordResponseFromJson(
  Map<String, dynamic> json,
) => ResetPasswordResponse(message: json['message'] as String?);

Map<String, dynamic> _$ResetPasswordResponseToJson(
  ResetPasswordResponse instance,
) => <String, dynamic>{'message': instance.message};
