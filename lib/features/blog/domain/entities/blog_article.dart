import 'package:flutter/foundation.dart';

@immutable
class BlogArticle {
  const BlogArticle({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.publishedAt,
    required this.summary,
    required this.summaryAr,
    required this.content,
    required this.contentAr,
    required this.imageUrls,
  });

  final String id;
  final String title;
  final String titleAr;
  final DateTime publishedAt;
  final String summary;
  final String summaryAr;
  final String content;
  final String contentAr;
  final List<String> imageUrls;

  String get formattedDate =>
      '${publishedAt.day.toString().padLeft(2, '0')}/${publishedAt.month.toString().padLeft(2, '0')}/${publishedAt.year}';
}
