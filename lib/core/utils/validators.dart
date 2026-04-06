/// Centralized input validation.
///
/// Returns a non-null error string on failure, null on success.
/// Used by Form field validators AND by notifiers before API calls.
class Validators {
  /// Name must be non-empty and at least 2 characters.
  static String? name(String? value, {String label = 'Name'}) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    if (value.trim().length < 2) return '$label must be at least 2 characters';
    return null;
  }

  /// Standard email format check.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Password must be at least 6 characters.
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Phone: digits, spaces, hyphens, parentheses, optional leading +.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\+?[0-9\s\-\(\)]{6,}$').hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Generic required-field check.
  static String? required(String? value, {String label = 'Field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  /// Chat message / prompt: non-empty after trimming.
  static String? prompt(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter a message';
    if (value.trim().length > 2000) return 'Message is too long (max 2000 characters)';
    return null;
  }

  /// Returns all validation errors as a list (for notifier-level validation).
  /// Pass field-name → validator pairs.
  static List<String> validateAll(Map<String, String? Function()> fields) {
    return fields.entries
        .map((e) => e.value())
        .whereType<String>()
        .toList();
  }
}
