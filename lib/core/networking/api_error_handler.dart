import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'api_error_model.dart';

/// Represents different types of API errors that can occur
enum ApiErrorType {
  /// Success with no content (204)
  noContent(ResponseCode.NO_CONTENT, ApiErrors.noContent),

  /// Resource created successfully (201)
  created(ResponseCode.CREATED, ApiErrors.created),

  /// Bad request error (400)
  badRequest(ResponseCode.BAD_REQUEST, ApiErrors.badRequestError),

  /// Unauthorized error (401)
  unauthorized(ResponseCode.UNAUTORISED, ApiErrors.unauthorizedError),

  /// Forbidden error (403)
  forbidden(ResponseCode.FORBIDDEN, ApiErrors.forbiddenError),

  /// Resource not found (404)
  notFound(ResponseCode.NOT_FOUND, ApiErrors.notFoundError),

  /// Internal server error (500)
  internalServer(
    ResponseCode.INTERNAL_SERVER_ERROR,
    ApiErrors.internalServerError,
  ),

  /// Connection timeout
  connectTimeout(ResponseCode.CONNECT_TIMEOUT, ApiErrors.timeoutError),

  /// Request cancelled
  cancelled(ResponseCode.CANCEL, ApiErrors.defaultError),

  /// Receive timeout
  receiveTimeout(ResponseCode.RECIEVE_TIMEOUT, ApiErrors.timeoutError),

  /// Send timeout
  sendTimeout(ResponseCode.SEND_TIMEOUT, ApiErrors.timeoutError),

  /// Cache error
  cacheError(ResponseCode.CACHE_ERROR, ApiErrors.cacheError),

  /// No internet connection
  noInternet(ResponseCode.NO_INTERNET_CONNECTION, ApiErrors.noInternetError),

  /// Default error
  defaultError(ResponseCode.DEFAULT, ApiErrors.defaultError);

  final int code;
  final String message;

  const ApiErrorType(this.code, this.message);

  /// Converts the error type to an [ApiErrorModel]
  ApiErrorModel toErrorModel() => ApiErrorModel(code: code, message: message);
}

String _localizeMessage(String message) {
  final trimmedMessage = message.trim();
  switch (trimmedMessage) {
    case 'These credentials do not match our records.':
      return 'بيانات تسجيل الدخول غير صحيحة';
    default:
      return message;
  }
}

/// HTTP status codes used in the API
class ResponseCode {
  // Server response codes
  static const int SUCCESS = 200;
  static const int CREATED = 201;
  static const int NO_CONTENT = 204;
  static const int BAD_REQUEST = 400;
  static const int UNAUTORISED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int API_LOGIC_ERROR = 422;
  static const int INTERNAL_SERVER_ERROR = 500;

  // Local error codes
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;

  const ResponseCode._();
}

/// Handles API errors and converts them to [ApiErrorModel]
class ErrorHandler implements Exception {
  final ApiErrorModel apiErrorModel;

  // Can't have a body in a const constructor, so removing const
  ErrorHandler._(this.apiErrorModel) {
    print(
      'ErrorHandler constructor called with message: ${apiErrorModel.message}',
    );
  }

  /// Creates an [ErrorHandler] from a dynamic error
  factory ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      return ErrorHandler._(_handleDioError(error));
    }
    return ErrorHandler._(ApiErrorType.defaultError.toErrorModel());
  }

  /// Creates an [ErrorHandler] with a custom error message
  factory ErrorHandler.withMessage(String message) {
    print(
      'ErrorHandler.withMessage: Creating error model with message: $message',
    );
    final localizedMessage = _localizeMessage(message);
    final errorModel = ApiErrorModel(message: localizedMessage);
    print(
      'ErrorHandler.withMessage: Created error model with message: ${errorModel.message}',
    );
    return ErrorHandler._(errorModel);
  }

  /// Handles Dio specific errors
  static ApiErrorModel _handleDioError(DioException error) {
    print('_handleDioError: Processing error of type ${error.type}');
    if (error.error is ApiErrorModel) {
      print(
        '_handleDioError: Error is already an ApiErrorModel with message: ${(error.error as ApiErrorModel).message}',
      );
      return error.error as ApiErrorModel;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiErrorType.connectTimeout.toErrorModel();

      case DioExceptionType.sendTimeout:
        return ApiErrorType.sendTimeout.toErrorModel();

      case DioExceptionType.receiveTimeout:
        return ApiErrorType.receiveTimeout.toErrorModel();

      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        if (error.response != null) {
          print(
            '_handleDioError: Response received with data: ${error.response!.data}',
          );
          final dynamic responseData = error.response!.data;

          // Handle response data as Map - most common case
          if (responseData is Map) {
            // Check if the response data contains a message field directly
            if (responseData.containsKey('message')) {
              final message = responseData['message'];
              print('_handleDioError: Found message in Map response: $message');
              return ApiErrorModel(
                message: _localizeMessage(message.toString()),
              );
            }

            // Check for status field and message together
            if (responseData.containsKey('status') &&
                responseData.containsKey('message')) {
              final status = responseData['status'];
              if (status == 'failed') {
                final message = responseData['message'];
                print(
                  '_handleDioError: Found failed status with message: $message',
                );
                return ApiErrorModel(
                  message: _localizeMessage(message.toString()),
                );
              }
            }
          }

          // Handle non-Map objects with status and message fields
          try {
            if (responseData != null) {
              // Try to access status and message directly as properties
              final dynamic status = responseData.status;
              if (status == 'failed' || status == 'error') {
                final dynamic message = responseData.message;
                if (message != null) {
                  print('_handleDioError: Found message property: $message');
                  return ApiErrorModel(
                    message: _localizeMessage(message.toString()),
                  );
                }
              }
            }
          } catch (e) {
            print('_handleDioError: Error accessing properties: $e');
          }

          // If we have a status message, use that
          if (error.response!.statusMessage != null) {
            return ApiErrorModel(
              message: _localizeMessage(error.response!.statusMessage!),
            );
          }
        }
        print(
          '_handleDioError: Could not extract error message, returning default error',
        );
        return ApiErrorType.defaultError.toErrorModel();

      case DioExceptionType.cancel:
        return ApiErrorType.cancelled.toErrorModel();

      case DioExceptionType.connectionError:
        return ApiErrorType.noInternet.toErrorModel();

      case DioExceptionType.badCertificate:
        return ApiErrorType.defaultError.toErrorModel();
    }
  }

  /// Checks if the error response contains valid data
  static bool _isValidErrorResponse(Response? response) {
    return response != null &&
        response.statusCode != null &&
        response.statusMessage != null &&
        response.data != null;
  }
}

/// Internal API status codes
class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;

  const ApiInternalStatus._();
}
