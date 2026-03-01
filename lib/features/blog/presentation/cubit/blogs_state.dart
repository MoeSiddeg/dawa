import '../../domain/entities/blog_entity.dart';

abstract class BlogsState {}

class BlogsInitial extends BlogsState {}

class BlogsLoading extends BlogsState {}

class BlogsSuccess extends BlogsState {
  final List<BlogEntity> blogs;
  final bool hasMore;
  final int currentPage;

  BlogsSuccess({
    required this.blogs,
    required this.hasMore,
    required this.currentPage,
  });
}

class BlogsEmpty extends BlogsState {}

class BlogsError extends BlogsState {
  final String message;

  BlogsError(this.message);
}
