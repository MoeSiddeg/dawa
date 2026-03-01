import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/entities/blog_entity.dart';
import '../../domain/repositories/blogs_repository.dart';

class BlogsRepositoryImpl extends BaseRepository implements BlogsRepository {
  final ApiService _apiService;

  BlogsRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<List<BlogEntity>>> getBlogs({int page = 1}) async {
    return executeApiCall(() async {
      final response = await _apiService.getBlogs(page: page);
      final blogs =
          response.data?.data
              ?.map((data) => BlogEntity.fromData(data))
              .toList() ??
          [];
      return blogs;
    });
  }

  @override
  Future<ApiResult<BlogEntity>> getBlogDetails(int id) async {
    return executeApiCall(() async {
      final response = await _apiService.getBlogDetails(id);
      if (response.data == null) {
        throw Exception('Blog not found');
      }
      return BlogEntity.fromData(response.data!);
    });
  }
}
