import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/entities/page_content_entity.dart';
import '../../domain/repositories/pages_repository.dart';
import '../models/page_content_response.dart';

class PagesRepositoryImpl extends BaseRepository implements PagesRepository {
  final ApiService _apiService;

  PagesRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<PageContentEntity>> getAboutUs() async {
    return executeApiCall(() async {
      final response = await _apiService.getAboutUs();
      return _mapToEntity(response);
    });
  }

  @override
  Future<ApiResult<PageContentEntity>> getHelp() async {
    return executeApiCall(() async {
      final response = await _apiService.getHelp();
      return _mapToEntity(response);
    });
  }

  @override
  Future<ApiResult<PageContentEntity>> getPrivacyPolicy() async {
    return executeApiCall(() async {
      final response = await _apiService.getPrivacyPolicy();
      return _mapToEntity(response);
    });
  }

  @override
  Future<ApiResult<PageContentEntity>> getTermsOfUse() async {
    return executeApiCall(() async {
      final response = await _apiService.getTermsOfUse();
      return _mapToEntity(response);
    });
  }

  PageContentEntity _mapToEntity(PageContentResponse response) {
    final data = response.data;
    if (data == null) {
      throw Exception('No data found');
    }
    return PageContentEntity(
      id: data.id,
      name: data.name,
      alias: data.alias,
      description: data.description,
    );
  }
}
