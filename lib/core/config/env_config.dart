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

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  /// Google Gemini API key.
  static String? get geminiApiKey => _clean(dotenv.env['GEMINI_API_KEY']);

  /// Mercury provider API key.
  static String? get mercuryApiKey => _clean(dotenv.env['MERCURY_API_KEY']);

  /// Optional OpenAI API key for GPT-labeled models.
  static String? get openAiApiKey => _clean(dotenv.env['OPENAI_API_KEY']);

    /// Base URL for Mercury endpoint (Inception Labs).
  static String get mercuryBaseUrl =>
      _clean(dotenv.env['MERCURY_BASE_URL']) ??
      'https://api.inceptionlabs.ai/v1/chat/completions';

  /// Model name used for Mercury endpoint calls.
  static String get mercuryModel =>
      _clean(dotenv.env['MERCURY_MODEL']) ?? 'mercury-2';

  /// Base URL for OpenAI endpoint calls.
  static String get openAiBaseUrl =>
      _clean(dotenv.env['OPENAI_BASE_URL']) ??
      'https://api.openai.com/v1/chat/completions';

  /// Default OpenAI model for non-Gemini providers.
  static String get openAiModel =>
      _clean(dotenv.env['OPENAI_MODEL']) ?? 'gpt-4o-mini';
}
