import '../../data/models/blogs_response.dart';

class BlogEntity {
  final int id;
  final String? name;
  final String? alias;
  final String? image;
  final String? description;
  final String? template;
  final List<String>? images;

  BlogEntity({
    required this.id,
    this.name,
    this.alias,
    this.image,
    this.description,
    this.template,
    this.images,
  });

  factory BlogEntity.fromData(BlogData data) {
    return BlogEntity(
      id: data.id ?? 0,
      name: data.name,
      alias: data.alias,
      image: data.image,
      description: data.description,
      template: data.template,
      images: data.images,
    );
  }
}
