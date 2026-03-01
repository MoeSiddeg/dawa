import '../../../../core/networking/api_result.dart';
import '../entities/page_content_entity.dart';

abstract class PagesRepository {
  Future<ApiResult<PageContentEntity>> getAboutUs();
  Future<ApiResult<PageContentEntity>> getHelp();
  Future<ApiResult<PageContentEntity>> getPrivacyPolicy();
  Future<ApiResult<PageContentEntity>> getTermsOfUse();
}
