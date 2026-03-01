import 'package:json_annotation/json_annotation.dart';

part 'send_message_request.g.dart';

@JsonSerializable()
class SendMessageRequest {
  final String name;
  final String email;
  final String phone;
  final String message;

  SendMessageRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  });

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}
