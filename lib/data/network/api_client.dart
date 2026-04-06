import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/errors/app_exception.dart';
import '../../core/config/env_config.dart';

/// Abstract HTTP client contract.
///
/// The app never calls `http.get()` directly — it always goes through this.
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers});

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  Future<void> delete(String path, {Map<String, String>? headers});

  /// Uploads a file using multipart form data.
  Future<Map<String, dynamic>> multipartUpload(
    String path, {
    required File file,
    required String fileField,
    Map<String, String>? fields,
    Map<String, String>? headers,
  });
}

class TimeoutExceptionLocal extends AppException {
  const TimeoutExceptionLocal(String message) : super(message);
}

/// Real HTTP implementation (ready for Railway).
class HttpApiClient implements ApiClient {
  final String _baseUrl;
  // TODO: Authentication Readiness - Inject real auth token or a TokenProvider here
  final String? _authToken;
  final http.Client _client;

  HttpApiClient({String? baseUrl, String? authToken, http.Client? client})
      : _baseUrl = baseUrl ?? EnvConfig.baseUrl,
        _authToken = authToken,
        _client = client ?? http.Client();

  Map<String, String> _defaultHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Duration get _timeout => Duration(seconds: EnvConfig.requestTimeoutSeconds);

  void _log(String message) {
    if (kDebugMode) {
      print('[HttpApiClient] $message');
    }
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    _log('Response status: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw const NetworkException('Invalid JSON response format.');
      }
    }
    
    // Attempt to extract an error message from the body
    String errorMessage = 'Server error';
    try {
      final errorBody = jsonDecode(response.body);
      if (errorBody['message'] != null) {
        errorMessage = errorBody['message'];
      }
    } catch (_) {}

    if (response.statusCode == 401) throw AuthException(errorMessage);
    if (response.statusCode == 404) throw NotFoundException(errorMessage);
    throw NetworkException(errorMessage, statusCode: response.statusCode);
  }

  Future<T> _executeWithRetry<T>(Future<T> Function() request, {int retries = 1}) async {
    int attempts = 0;
    while (attempts <= retries) {
      try {
        return await request().timeout(_timeout);
      } on TimeoutException {
        if (attempts >= retries) throw const TimeoutExceptionLocal('Request timed out. Please check your connection.');
      } on SocketException {
        throw const NetworkException('No internet connection.');
      } catch (e) {
        if (attempts >= retries) rethrow;
      }
      attempts++;
      _log('Retrying request... ($attempts)');
      await Future.delayed(Duration(milliseconds: 500 * attempts));
    }
    throw const NetworkException('Request failed after retries.');
  }

  @override
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    _log('GET $_baseUrl$path');
    final response = await _executeWithRetry(() => _client.get(
          Uri.parse('$_baseUrl$path'),
          headers: {..._defaultHeaders(), ...?headers},
        ));
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    _log('POST $_baseUrl$path');
    final response = await _executeWithRetry(() => _client.post(
          Uri.parse('$_baseUrl$path'),
          headers: {..._defaultHeaders(), ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ));
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    _log('PUT $_baseUrl$path');
    final response = await _executeWithRetry(() => _client.put(
          Uri.parse('$_baseUrl$path'),
          headers: {..._defaultHeaders(), ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ));
    return _handleResponse(response);
  }

  @override
  Future<void> delete(String path, {Map<String, String>? headers}) async {
    _log('DELETE $_baseUrl$path');
    final response = await _executeWithRetry(() => _client.delete(
          Uri.parse('$_baseUrl$path'),
          headers: {..._defaultHeaders(), ...?headers},
        ));
    await _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> multipartUpload(
    String path, {
    required File file,
    required String fileField,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    _log('MULTIPART $_baseUrl$path');
    return await _executeWithRetry(() async {
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$path'));
      
      request.headers.addAll({..._defaultHeaders(), ...?headers});
      
      if (fields != null) {
        request.fields.addAll(fields);
      }

      request.files.add(
        await http.MultipartFile.fromPath(fileField, file.path),
      );

      final streamedResponse = await _client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    });
  }
}

/// Mock implementation — returns canned responses instantly.
/// Keeping this available for switching easily.
class MockApiClient implements ApiClient {
  @override
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'ok', 'path': path};
  }

  @override
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'created', 'path': path, ...?body};
  }

  @override
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'updated', 'path': path, ...?body};
  }

  @override
  Future<void> delete(String path, {Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
  
  @override
  Future<Map<String, dynamic>> multipartUpload(
    String path, {
    required File file,
    required String fileField,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'uploaded', 'path': path, 'file': file.path};
  }
}
