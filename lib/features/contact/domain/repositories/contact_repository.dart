import '../../../../core/networking/api_result.dart';
import '../../data/models/send_message_request.dart';

abstract class ContactRepository {
  Future<ApiResult<String>> sendMessage(SendMessageRequest request);
}
