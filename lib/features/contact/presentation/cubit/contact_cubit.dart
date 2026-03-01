import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/send_message_request.dart';
import '../../domain/repositories/contact_repository.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository _repository;

  ContactCubit(this._repository) : super(ContactInitial());

  Future<void> sendMessage({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    emit(ContactLoading());

    final request = SendMessageRequest(
      name: name,
      email: email,
      phone: phone,
      message: message,
    );

    final result = await _repository.sendMessage(request);

    result.when(
      success: (msg) {
        emit(ContactSuccess(msg));
      },
      failure: (error) {
        emit(ContactError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }

  void reset() {
    emit(ContactInitial());
  }
}
