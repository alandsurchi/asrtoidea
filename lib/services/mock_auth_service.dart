import 'dart:math';

/// Mock service simulating a backend interaction securely mapping validations
/// without leaking logical faults randomly throughout the codebase.
class MockAuthService {
  static Future<bool> updateUserProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    // Artificial network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate standard server-side string checking constraints locally
    if (name.isEmpty || name.length < 2) {
      throw Exception('Server Validation Failed: Name must be at least 2 characters long.');
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Server Validation Failed: Invalid email format.');
    }

    // Produce an arbitrary 5% intentional failure mimicking API instability constraints seamlessly
    final random = Random();
    if (random.nextDouble() < 0.05) {
      throw Exception('Network Error: Could not connect to authentication services.');
    }

    // Success
    return true;
  }
}
