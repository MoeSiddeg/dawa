import 'package:dio/dio.dart';

import 'api_error_handler.dart';
import 'api_result.dart';

/// Base repository class that provides standardized error handling for API calls
class BaseRepository {
  /// Executes an API call and directly throws error messages from the server
  /// This follows the same pattern as your UpdateAccountRepository
  ///
  /// [apiCall] is the function that makes the actual API call
  /// [failedMessage] is the default error message to use if no specific message is available
  /// [checkData] determines whether to check if the response data is null
  Future<T> executeDirectApiCall<T>({
    required Future<T> Function() apiCall,
    String failedMessage = 'An error occurred',
    bool checkData = true,
  }) async {
    try {
      // Make the API call
      final response = await apiCall();

      // Check if the response has a status field
      if (response != null && _hasStatusField(response)) {
        final dynamic obj = response;

        // Check if the response status is failed
        if (obj.status == 'failed') {
          throw obj.message ?? failedMessage;
        }

        // Check if data is null (if required)
        if (checkData && _hasDataField(obj) && obj.data == null) {
          throw 'Invalid response data';
        }
      }

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic> &&
            errorData.containsKey('message')) {
          throw errorData['message'] as String;
        }
      }
      throw failedMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Helper method to check if an object has a status field
  bool _hasStatusField(dynamic obj) {
    try {
      final status = obj.status;
      return status != null;
    } catch (e) {
      return false;
    }
  }

  // Helper method to check if an object has a data field
  bool _hasDataField(dynamic obj) {
    try {
      // Just access the field to see if it exists, ignore the value
      obj.data;
      return true; // We only care if the field exists, not if it's null
    } catch (e) {
      return false;
    }
  }

  /// Creates a Dio instance with common headers and settings for direct API calls
  /// This is useful when you need to bypass Retrofit for specific API calls

  /// Handles a response from the server, checking for success/failed status
  /// and returning the appropriate ApiResult
  /// Handles a response from the server, checking for success/failed status
  /// and returning the appropriate ApiResult
  ApiResult<T> handleApiResponse<T>({
    required Map<String, dynamic>? responseData,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    // Check if responseData is null
    if (responseData == null) {
      print('BaseRepository: Response data is null');
      return ApiResult.failure(
        ErrorHandler.withMessage('Response data is null'),
      );
    }

    // Check the status field
    if (responseData.containsKey('status')) {
      if (responseData['status'] == "success") {
        // Success case - return the data
        return ApiResult.success(fromJson(responseData));
      } else if (responseData['status'] == "failed") {
        // Failed case - return the error message directly from the server
        final String errorMessage =
            responseData['message']?.toString() ?? 'Unknown error';
        print(
          'BaseRepository: Found failed status with message: $errorMessage',
        );
        return ApiResult.failure(ErrorHandler.withMessage(errorMessage));
      }
    }

    // If we get here, it's an unexpected response format
    print('BaseRepository: Unexpected response format: $responseData');
    return ApiResult.failure(
      ErrorHandler.withMessage('Unexpected response format'),
    );
  }

  /// Executes an API call and handles the response in a standardized way
  Future<ApiResult<T>> executeApiCall<T, R>(
    Future<R> Function() apiCall, {
    T Function(R response)? successHandler,
  }) async {
    try {
      final response = await apiCall();

      // Check if response is a Map<String, dynamic> (common for API responses)
      if (response is Map<String, dynamic>) {
        if (response.containsKey('status') && response['status'] == 'failed') {
          final String errorMessage =
              response['message']?.toString() ?? 'Unknown error';
          print(
            'BaseRepository: Found failed status in Map with message: $errorMessage',
          );
          return ApiResult.failure(ErrorHandler.withMessage(errorMessage));
        }
        // If successHandler is provided, use it
        if (successHandler != null) {
          return ApiResult.success(successHandler(response));
        }
        return ApiResult.success(response as T);
      }

      // Check for failed status in custom objects
      if (_hasStatusAndMessage(response)) {
        final dynamic obj = response;
        if (obj.status == 'failed') {
          final String errorMessage =
              obj.message?.toString() ?? 'Unknown error';
          print(
            'BaseRepository: Found failed status with message: $errorMessage',
          );
          return ApiResult.failure(ErrorHandler.withMessage(errorMessage));
        }
        // For successful responses
        if (obj.status == 'success') {
          if (successHandler != null) {
            return ApiResult.success(successHandler(response));
          }
          return ApiResult.success(response as T);
        }
      }

      // Handle other response types
      if (successHandler != null) {
        return ApiResult.success(successHandler(response));
      }
      return ApiResult.success(response as T);
    } catch (error) {
      print('BaseRepository: Caught error: $error');

      // Handle DioException specifically
      if (error is DioException && error.response?.data != null) {
        final dynamic responseData = error.response!.data;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('status')) {
          if (responseData['status'] == 'failed') {
            final String errorMessage =
                responseData['message']?.toString() ?? 'Unknown error';
            print(
              'BaseRepository: Found failed status in error response with message: $errorMessage',
            );
            return ApiResult.failure(ErrorHandler.withMessage(errorMessage));
          }
          if (responseData.containsKey('message')) {
            final String errorMessage = responseData['message'].toString();
            print(
              'BaseRepository: Extracted error message from DioException: $errorMessage',
            );
            return ApiResult.failure(ErrorHandler.withMessage(errorMessage));
          }
        }
        // Fall back to error.message if available
        if (error.message != null) {
          return ApiResult.failure(ErrorHandler.withMessage(error.message!));
        }
      }

      // For other types of errors
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  /// Executes an API call and handles the response in a standardized way
  ///
  // Helper method to check if a custom object has status and message fields
  bool _hasStatusAndMessage(dynamic obj) {
    try {
      // Try to access status and message fields
      final status = obj.status;
      final message = obj.message;
      return status != null && message != null;
    } catch (e) {
      return false;
    }
  }
}
