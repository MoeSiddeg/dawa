import '../../../../core/networking/api_result.dart';
import '../entities/blog_entity.dart';

abstract class BlogsRepository {
  Future<ApiResult<List<BlogEntity>>> getBlogs({int page = 1});
  Future<ApiResult<BlogEntity>> getBlogDetails(int id);
}
