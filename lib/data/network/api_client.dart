// NOTE: When activating HttpApiClient below, add this import:
// import '../../core/errors/app_exception.dart';

/// Abstract HTTP client contract.
///
/// The app never calls `http.get()` directly — it always goes through this.
/// Swap [MockApiClient] for [HttpApiClient] (using `http` or `dio`) to go live.
abstract class ApiClient {
  /// Sends a GET request and returns the decoded response body.
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers});

  /// Sends a POST request with a JSON [body] and returns the decoded response.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Sends a PUT request with a JSON [body] and returns the decoded response.
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Sends a DELETE request.
  Future<void> delete(String path, {Map<String, String>? headers});
}

/// Mock implementation — returns canned responses instantly.
/// Useful for unit testing and development without a running server.
class MockApiClient implements ApiClient {
  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'ok', 'path': path};
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'created', 'path': path, ...?body};
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'updated', 'path': path, ...?body};
  }

  @override
  Future<void> delete(String path, {Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

/// Real HTTP implementation (activate when backend is ready).
///
/// Uncomment and add `http: ^1.x` to pubspec.yaml to enable.
///
/// ```dart
/// class HttpApiClient implements ApiClient {
///   final String _baseUrl;
///   final String? _authToken;
///   final http.Client _client;
///
///   HttpApiClient({required String baseUrl, String? authToken})
///       : _baseUrl = baseUrl,
///         _authToken = authToken,
///         _client = http.Client();
///
///   Map<String, String> _defaultHeaders() => {
///     'Content-Type': 'application/json',
///     'Accept': 'application/json',
///     if (_authToken != null) 'Authorization': 'Bearer $_authToken',
///   };
///
///   Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
///     if (response.statusCode >= 200 && response.statusCode < 300) {
///       return jsonDecode(response.body) as Map<String, dynamic>;
///     }
///     if (response.statusCode == 401) throw const AuthException('Session expired.');
///     if (response.statusCode == 404) throw const NotFoundException('Resource not found.');
///     throw NetworkException('Server error', statusCode: response.statusCode);
///   }
///
///   @override
///   Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
///     final response = await _client.get(
///       Uri.parse('$_baseUrl$path'),
///       headers: {..._defaultHeaders(), ...?headers},
///     );
///     return _handleResponse(response);
///   }
///   // ... post, put, delete — same pattern
/// }
/// ```
