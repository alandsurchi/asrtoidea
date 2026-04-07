import '../../domain/models/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';
import '../../core/errors/app_exception.dart';

/// Network implementation of [AuthRepository].
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;

  ApiAuthRepository(this._apiClient);

  @override
  Future<UserProfile> getUserProfile() async {
    // TODO: Connecting to Railway endpoint...
    // Example: GET /auth/profile
    // Uses token from ApiClient (which needs to be injected)
    final response = await _apiClient.get('/auth/profile');
    
    // Assuming UserProfile has fromJson factory or we create one
    // We map ignoring for now if UserProfile doesn't have fromJson perfectly, we assume it does based on plan
    final apiResponse = ApiResponse<UserProfile>.fromJson(
      response,
      (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.data == null) throw Exception('Profile data is null.');
    return apiResponse.data!;
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    // TODO: Connecting to Railway endpoint...
    // Example: PUT /auth/profile
    final response = await _apiClient.put(
      '/auth/profile',
      body: profile.toJson(),
    );

    final apiResponse = ApiResponse<UserProfile>.fromJson(
      response,
      (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.data == null) throw Exception('Failed to update profile.');
    return apiResponse.data!;
  }

  @override
  Future<String> signIn(String email, String password) async {
    final identifier = email.trim();
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': identifier,
        'identifier': identifier,
        'password': password,
      },
    );

    final token = _extractToken(response);
    if (token != null) return token;
    throw AuthException(_extractMessage(response, 'Login failed. No token received.'));
  }

  @override
  Future<String> signUp(String name, String email, String password) async {
    final response = await _apiClient.post(
      '/auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );

    final token = _extractToken(response);
    if (token != null) return token;
    throw AuthException(_extractMessage(response, 'Sign up failed. No token received.'));
  }

  @override
  Future<void> signOut() async {
    // Standard sign out doesn't necessarily need a backend call unless we are invalidating sessions.
    // If there's an endpoint, it would be called here.
    return Future.value();
  }

  String? _extractToken(Map<String, dynamic> response) {
    final direct = response['token'];
    if (direct is String && direct.trim().isNotEmpty) {
      return direct.trim();
    }

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['token'];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
    }

    return null;
  }

  String _extractMessage(Map<String, dynamic> response, String fallback) {
    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    return fallback;
  }
}
