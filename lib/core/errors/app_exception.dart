/// Base class for all application-level exceptions.
/// All concrete errors extend this — catch [AppException] to handle any app error.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Thrown when user input fails validation rules.
class ValidationException extends AppException {
  /// The field that failed (e.g. 'email', 'name'). Null = form-level error.
  final String? field;
  const ValidationException(String message, {this.field}) : super(message);
}

/// Thrown when a network/API call fails.
class NetworkException extends AppException {
  /// HTTP status code if available (e.g. 401, 500).
  final int? statusCode;
  const NetworkException(String message, {this.statusCode}) : super(message);
}

/// Thrown for authentication-specific failures (bad credentials, session expired).
class AuthException extends AppException {
  const AuthException(String message) : super(message);
}

/// Thrown when local storage read/write fails.
class StorageException extends AppException {
  const StorageException(String message) : super(message);
}

/// Thrown when a requested resource is not found (404-equivalent).
class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message);
}

/// Converts any [dynamic] error into a user-readable string.
/// Strips Dart's "Exception: " prefix, returns a fallback if empty.
String appErrorMessage(Object error, {String fallback = 'Something went wrong.'}) {
  if (error is AppException) return error.message;
  final raw = error.toString();
  if (raw.startsWith('Exception: ')) return raw.substring('Exception: '.length);
  return raw.isNotEmpty ? raw : fallback;
}
