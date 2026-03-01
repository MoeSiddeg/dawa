import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final bool? status;
  final String? message;
  final RegisterData? data;
  final List<dynamic>? errors;
  final Map<String, dynamic>? custom;

  RegisterResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RegisterData {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? accessToken;
  final String? tokenType;

  RegisterData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.accessToken,
    this.tokenType,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
