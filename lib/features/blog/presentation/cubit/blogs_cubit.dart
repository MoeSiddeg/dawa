import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blog_entity.dart';
import '../../domain/repositories/blogs_repository.dart';
import 'blogs_state.dart';

class BlogsCubit extends Cubit<BlogsState> {
  final BlogsRepository _repository;

  List<BlogEntity> _blogs = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  BlogsCubit(this._repository) : super(BlogsInitial());

  Future<void> loadBlogs() async {
    emit(BlogsLoading());
    _currentPage = 1;
    _blogs = [];
    _hasMore = true;

    final result = await _repository.getBlogs(page: _currentPage);

    result.when(
      success: (blogs) {
        _blogs = blogs;
        _hasMore = blogs.isNotEmpty;
        if (_blogs.isEmpty) {
          emit(BlogsEmpty());
        } else {
          emit(
            BlogsSuccess(
              blogs: _blogs,
              hasMore: _hasMore,
              currentPage: _currentPage,
            ),
          );
        }
      },
      failure: (error) {
        emit(BlogsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    _currentPage++;

    final result = await _repository.getBlogs(page: _currentPage);

    result.when(
      success: (blogs) {
        if (blogs.isEmpty) {
          _hasMore = false;
          _currentPage--;
        } else {
          _blogs = [..._blogs, ...blogs];
        }
        emit(
          BlogsSuccess(
            blogs: _blogs,
            hasMore: _hasMore,
            currentPage: _currentPage,
          ),
        );
      },
      failure: (error) {
        _currentPage--;
        emit(BlogsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );

    _isLoadingMore = false;
  }

  Future<void> refresh() async {
    await loadBlogs();
  }
}
