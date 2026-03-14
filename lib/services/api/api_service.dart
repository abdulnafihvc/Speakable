import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

/// API Response wrapper with loading, success, and error states
class ApiResponse<T> {
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final T? data;
  final String? errorMessage;

  const ApiResponse({
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.data,
    this.errorMessage,
  });

  factory ApiResponse.loading() => const ApiResponse(isLoading: true);

  factory ApiResponse.success(T data) => ApiResponse(
        isSuccess: true,
        data: data,
      );

  factory ApiResponse.error(String message) => ApiResponse(
        isError: true,
        errorMessage: message,
      );
}

/// Reusable API service with error handling and timeout management
class ApiService extends GetxService {
  final String baseUrl;
  final Duration timeout;

  ApiService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  /// GET request
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(uri, headers: headers).timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    T Function(dynamic)? parser,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    T Function(dynamic)? parser,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .put(
            uri,
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response =
          await http.delete(uri, headers: headers).timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? parser,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        final data = parser != null ? parser(decoded) : decoded as T;
        return ApiResponse.success(data);
      } catch (e) {
        return ApiResponse.error('Failed to parse response: ${e.toString()}');
      }
    } else if (response.statusCode == 401) {
      return ApiResponse.error('Unauthorized. Please login again.');
    } else if (response.statusCode == 404) {
      return ApiResponse.error('Resource not found.');
    } else if (response.statusCode >= 500) {
      return ApiResponse.error('Server error. Please try again later.');
    } else {
      return ApiResponse.error(
        'Request failed with status: ${response.statusCode}',
      );
    }
  }
}
