import 'package:json_annotation/json_annotation.dart';

part 'reset_password_models.g.dart';

// Request Models
@JsonSerializable()
class SendOtpRequest {
  final String email;

  SendOtpRequest({required this.email});

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String password;

  ResetPasswordRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

// Response Models
@JsonSerializable()
class ResetPasswordResponse {
  final String? message;

  ResetPasswordResponse({this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}
