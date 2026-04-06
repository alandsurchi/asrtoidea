import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized Environment Configuration
/// 
/// safely accesses variables from the `.env` file, 
/// providing fallbacks to prevent crashes if missing.
class EnvConfig {
  static Future<void> init() async {
    // We try to load the .env file.
    // In a real app, you might want to print a warning if this fails.
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // Ignore if not found, since we provide fallbacks below
      // but log it if we had a logger here.
    }
  }

  /// The base URL for the backend API
  static String get baseUrl {
    // Support multiple environments (dev/staging/production) via .env
    // Ensure we don't crash by providing a default fallback.
    return dotenv.env['API_BASE_URL'] ?? 'https://your-app-production.up.railway.app/api/v1';
  }

  /// Request timeout in seconds
  static int get requestTimeoutSeconds {
    final timeoutStr = dotenv.env['REQUEST_TIMEOUT_SECONDS'];
    if (timeoutStr != null) {
      return int.tryParse(timeoutStr) ?? 30;
    }
    return 30;
  }
}
