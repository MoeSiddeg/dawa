import 'package:drugvet_master/core/service/storage_service.dart';
import 'package:drugvet_master/core/value/constant.dart';
import 'package:drugvet_master/features/auth/data/models/register_request_body.dart';
import 'package:drugvet_master/features/auth/data/models/register_response.dart';
import 'package:drugvet_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:drugvet_master/features/auth/presentation/cubit/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  RegisterCubit(this._authRepository, this._storageService)
    : super(const RegisterInitial());

  Future<void> register({required RegisterRequestBody body}) async {
    emit(const RegisterLoading());

    final result = await _authRepository.register(body: body);

    result.when(
      success: (response) async {
        if (response.status == true && response.data != null) {
          await _saveUserData(response.data!);
          emit(RegisterSuccess(response));
        } else {
          emit(RegisterError(response.message ?? 'Register failed'));
        }
      },
      failure: (error) {
        emit(RegisterError(error.apiErrorModel.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> _saveUserData(RegisterData userData) async {
    if (userData.accessToken != null) {
      await _storageService.setSecureToken(userData.accessToken!);
    }
    if (userData.name != null) {
      await _storageService.setString(
        AppConstants.STORAGE_USER_NAME,
        userData.name!,
      );
    }
    if (userData.id != null) {
      await _storageService.setUserId(userData.id!);
    }
  }
}
