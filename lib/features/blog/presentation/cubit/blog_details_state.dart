import '../../domain/entities/blog_entity.dart';

abstract class BlogDetailsState {}

class BlogDetailsInitial extends BlogDetailsState {}

class BlogDetailsLoading extends BlogDetailsState {}

class BlogDetailsSuccess extends BlogDetailsState {
  final BlogEntity blog;

  BlogDetailsSuccess(this.blog);
}

class BlogDetailsError extends BlogDetailsState {
  final String message;

  BlogDetailsError(this.message);
}
