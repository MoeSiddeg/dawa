class AdsResponse {
  final bool? status;
  final String? message;
  final List<AdData> data;
  final List<dynamic>? errors;
  final List<dynamic>? custom;

  AdsResponse({
    this.status,
    this.message,
    List<AdData>? data,
    this.errors,
    this.custom,
  }) : data = data ?? const [];

  factory AdsResponse.fromJson(Map<String, dynamic> json) {
    return AdsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => AdData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      errors: json['errors'] as List<dynamic>?,
      custom: json['custom'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((ad) => ad.toJson()).toList(),
    'errors': errors,
    'custom': custom,
  };
}

class AdData {
  final int? id;
  final int? position;
  final String? image;
  final String? link;

  const AdData({this.id, this.position, this.image, this.link});

  factory AdData.fromJson(Map<String, dynamic> json) {
    final rawPosition = json['position'];
    final position =
        rawPosition is int
            ? rawPosition
            : int.tryParse(rawPosition?.toString() ?? '');

    return AdData(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      position: position,
      image: json['image'] as String?,
      link: json['link'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': position,
    'image': image,
    'link': link,
  };
}
