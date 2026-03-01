import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/contact_repository.dart';
import '../models/send_message_request.dart';

class ContactRepositoryImpl extends BaseRepository
    implements ContactRepository {
  final ApiService _apiService;

  ContactRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<String>> sendMessage(SendMessageRequest request) async {
    return executeApiCall(() async {
      final response = await _apiService.sendMessage(request);
      return response.message ?? 'تم إرسال الرسالة بنجاح';
    });
  }
}
