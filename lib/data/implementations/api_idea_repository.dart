import '../../domain/models/ideas_dashboard_model.dart';
import '../../domain/repositories/idea_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';

/// Network implementation of [IdeaRepository].
class ApiIdeaRepository implements IdeaRepository {
  final ApiClient _apiClient;

  ApiIdeaRepository(this._apiClient);

  @override
  Future<List<IdeaCardModel>> getIdeas() async {
    // TODO: Connecting to Railway endpoint... (Add pagination here)
    // Example: GET /ideas?page=1&limit=20
    final response = await _apiClient.get('/ideas');
    
    final apiResponse = ApiResponse<List<IdeaCardModel>>.fromJson(
      response,
      (json) => (json as List).map((e) => IdeaCardModel.fromJson(e as Map<String, dynamic>)).toList(),
    );

    return apiResponse.data ?? [];
  }

  @override
  Future<IdeaCardModel> createIdea(IdeaCardModel idea) async {
    // TODO: Connecting to Railway endpoint...
    // Example: POST /ideas
    final response = await _apiClient.post(
      '/ideas',
      body: idea.toJson(),
    );

    final apiResponse = ApiResponse<IdeaCardModel>.fromJson(
      response,
      (json) => IdeaCardModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.data == null) throw Exception('Failed to parse created idea.');
    return apiResponse.data!;
  }

  @override
  Future<IdeaCardModel> updateIdea(IdeaCardModel idea) async {
    // TODO: Connecting to Railway endpoint...
    // Example: PUT /ideas/${idea.id}
    final response = await _apiClient.put(
      '/ideas/${idea.id}',
      body: idea.toJson(),
    );

    final apiResponse = ApiResponse<IdeaCardModel>.fromJson(
      response,
      (json) => IdeaCardModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.data == null) throw Exception('Failed to parse updated idea.');
    return apiResponse.data!;
  }

  @override
  Future<void> deleteIdea(String id) async {
    // TODO: Connecting to Railway endpoint...
    // Example: DELETE /ideas/$id
    await _apiClient.delete('/ideas/$id');
  }
}
