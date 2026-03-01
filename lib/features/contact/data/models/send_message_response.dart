import 'package:json_annotation/json_annotation.dart';

part 'send_message_response.g.dart';

@JsonSerializable()
class SendMessageResponse {
  final bool? status;
  final String? message;
  final dynamic data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  SendMessageResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}
