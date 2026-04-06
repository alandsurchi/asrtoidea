import '../../domain/models/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';

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
}
