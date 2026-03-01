import 'package:json_annotation/json_annotation.dart';

part 'blogs_response.g.dart';

@JsonSerializable()
class BlogsResponse {
  final bool? status;
  final String? message;
  final BlogsDataWrapper? data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  BlogsResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
    this.custom,
  });

  factory BlogsResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogsResponseToJson(this);
}

@JsonSerializable()
class BlogsDataWrapper {
  final List<BlogData>? data;
  final BlogLinks? links;
  final BlogMeta? meta;

  BlogsDataWrapper({this.data, this.links, this.meta});

  factory BlogsDataWrapper.fromJson(Map<String, dynamic> json) =>
      _$BlogsDataWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$BlogsDataWrapperToJson(this);
}

@JsonSerializable()
class BlogData {
  final int? id;
  final String? name;
  final String? alias;
  final String? image;
  final String? description;
  final String? template;
  @JsonKey(fromJson: _imagesFromJson, toJson: _imagesToJson)
  final List<String>? images;

  BlogData({
    this.id,
    this.name,
    this.alias,
    this.image,
    this.description,
    this.template,
    this.images,
  });

  factory BlogData.fromJson(Map<String, dynamic> json) =>
      _$BlogDataFromJson(json);

  Map<String, dynamic> toJson() => _$BlogDataToJson(this);

  static List<String>? _imagesFromJson(dynamic json) {
    if (json == null) return null;
    if (json is List) {
      if (json.isEmpty) return [];
      return json.whereType<String>().toList();
    }
    if (json is Map) {
      final urls = <String>[];
      for (final value in json.values) {
        if (value is Map && value['original_url'] != null) {
          urls.add(value['original_url'] as String);
        }
      }
      return urls;
    }
    return null;
  }

  static dynamic _imagesToJson(List<String>? images) => images;
}

@JsonSerializable()
class BlogLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  BlogLinks({this.first, this.last, this.prev, this.next});

  factory BlogLinks.fromJson(Map<String, dynamic> json) =>
      _$BlogLinksFromJson(json);

  Map<String, dynamic> toJson() => _$BlogLinksToJson(this);
}

@JsonSerializable()
class BlogMeta {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  final int? from;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  final List<BlogMetaLink>? links;
  final String? path;
  @JsonKey(name: 'per_page')
  final int? perPage;
  final int? to;
  final int? total;

  BlogMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory BlogMeta.fromJson(Map<String, dynamic> json) =>
      _$BlogMetaFromJson(json);

  Map<String, dynamic> toJson() => _$BlogMetaToJson(this);
}

@JsonSerializable()
class BlogMetaLink {
  final String? url;
  final String? label;
  final bool? active;

  BlogMetaLink({this.url, this.label, this.active});

  factory BlogMetaLink.fromJson(Map<String, dynamic> json) =>
      _$BlogMetaLinkFromJson(json);

  Map<String, dynamic> toJson() => _$BlogMetaLinkToJson(this);
}
