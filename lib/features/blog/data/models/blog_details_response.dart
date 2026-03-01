import 'package:json_annotation/json_annotation.dart';

import 'blogs_response.dart';

part 'blog_details_response.g.dart';

@JsonSerializable()
class BlogDetailsResponse {
  final bool? status;
  final String? message;
  final BlogData? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  BlogDetailsResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory BlogDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogDetailsResponseToJson(this);
}
