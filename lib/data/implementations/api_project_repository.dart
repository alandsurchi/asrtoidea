import '../../domain/models/project_card_model.dart';
import '../../domain/repositories/project_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';

/// Network implementation of [ProjectRepository].
class ApiProjectRepository implements ProjectRepository {
  final ApiClient _apiClient;

  ApiProjectRepository(this._apiClient);

  @override
  Future<List<ProjectCardModel>> getProjects() async {
    // TODO: Connecting to Railway endpoint...
    // Example: GET /projects
    final response = await _apiClient.get('/projects');
    
    // Using ApiResponse structure mapping
    final apiResponse = ApiResponse<List<ProjectCardModel>>.fromJson(
      response,
      (json) => (json as List).map((e) => ProjectCardModel.fromJson(e as Map<String, dynamic>)).toList(),
    );

    return apiResponse.data ?? [];
  }

  @override
  Future<ProjectCardModel> toggleSave(String projectId, bool isSaved) async {
    // TODO: Connecting to Railway endpoint...
    // Example: PUT /projects/$projectId/save
    final response = await _apiClient.put(
      '/projects/$projectId/save',
      body: {'isSaved': isSaved},
    );

    final apiResponse = ApiResponse<ProjectCardModel>.fromJson(
      response,
      (json) => ProjectCardModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to parse toggled project.');
    }
    return apiResponse.data!;
  }

  @override
  Future<ProjectCardModel> addComment(String projectId, String comment) async {
    // TODO: Connecting to Railway endpoint...
    // Example: POST /projects/$projectId/comments
    final response = await _apiClient.post(
      '/projects/$projectId/comments',
      body: {'comment': comment},
    );

    final apiResponse = ApiResponse<ProjectCardModel>.fromJson(
      response,
      (json) => ProjectCardModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.data == null) {
      throw Exception('Failed to parse commented project.');
    }
    return apiResponse.data!;
  }
}
