import 'dart:math';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation of [AuthRepository].
///
/// Simulates network latency and basic server-side validation.
/// Replace with [FirebaseAuthRepository] when backend is ready.
class MockAuthRepository implements AuthRepository {
  // In-memory session profile.
  UserProfile _currentProfile = UserProfile.guest();

  @override
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _currentProfile;
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 2));

    // Server-side validation simulation
    if (profile.name.trim().length < 2) {
      throw Exception('Server Validation Failed: Name must be at least 2 characters.');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(profile.email)) {
      throw Exception('Server Validation Failed: Invalid email format.');
    }

    // 5% random failure to simulate API instability in development
    if (Random().nextDouble() < 0.05) {
      throw Exception('Network Error: Could not connect to authentication service.');
    }

    _currentProfile = profile;
    return _currentProfile;
  }
}
