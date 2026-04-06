import '../../domain/models/user_profile.dart';

/// Contract defining user authentication and profile operations.
abstract class AuthRepository {
  /// Fetches the currently authenticated user's profile.
  Future<UserProfile> getUserProfile();

  /// Persists [profile] changes to the backend.
  Future<UserProfile> updateUserProfile(UserProfile profile);
}
