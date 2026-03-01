import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/blogs_repository.dart';
import 'blog_details_state.dart';

class BlogDetailsCubit extends Cubit<BlogDetailsState> {
  final BlogsRepository _repository;

  BlogDetailsCubit(this._repository) : super(BlogDetailsInitial());

  Future<void> loadBlogDetails(int blogId) async {
    emit(BlogDetailsLoading());

    final result = await _repository.getBlogDetails(blogId);

    result.when(
      success: (blog) {
        emit(BlogDetailsSuccess(blog));
      },
      failure: (error) {
        emit(BlogDetailsError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }
}
