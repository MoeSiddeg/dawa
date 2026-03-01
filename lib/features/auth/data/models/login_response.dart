import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool? status;
  final String? message;
  final UserData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  LoginResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UserData {
  final int? id;
  final String? name;
  final String? email;
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  final String? type;

  UserData({
    this.id,
    this.name,
    this.email,
    this.accessToken,
    this.tokenType,
    this.type,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
