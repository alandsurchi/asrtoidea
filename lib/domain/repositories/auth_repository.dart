import '../../domain/models/user_profile.dart';

/// Contract defining user authentication and profile operations.
abstract class AuthRepository {
  /// Fetches the currently authenticated user's profile.
  Future<UserProfile> getUserProfile();

  /// Persists [profile] changes to the backend.
  Future<UserProfile> updateUserProfile(UserProfile profile);

  /// Signs in a user with their [email] and [password]. Returns an auth token.
  Future<String> signIn(String email, String password);

  /// Signs up a new user. Returns an auth token.
  Future<String> signUp(String name, String email, String password);

  /// Signs the user out.
  Future<void> signOut();
}
