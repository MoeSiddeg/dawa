import '../../domain/entities/page_content_entity.dart';

abstract class PageContentState {}

class PageContentInitial extends PageContentState {}

class PageContentLoading extends PageContentState {}

class PageContentSuccess extends PageContentState {
  final PageContentEntity content;

  PageContentSuccess(this.content);
}

class PageContentError extends PageContentState {
  final String message;

  PageContentError(this.message);
}
