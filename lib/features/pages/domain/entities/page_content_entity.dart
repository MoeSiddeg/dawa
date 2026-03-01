class PageContentEntity {
  final int id;
  final String? name;
  final String? alias;
  final String? description;

  const PageContentEntity({
    required this.id,
    this.name,
    this.alias,
    this.description,
  });
}
