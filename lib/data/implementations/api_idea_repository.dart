import '../../domain/models/ideas_dashboard_model.dart';
import '../../domain/repositories/idea_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';
import '../../services/local_storage_service.dart';
import '../../core/errors/app_exception.dart';

/// Network implementation of [IdeaRepository].
class ApiIdeaRepository implements IdeaRepository {
  final ApiClient _apiClient;

  ApiIdeaRepository(this._apiClient);

  @override
  Future<List<IdeaCardModel>> getIdeas() async {
    // TODO: Connecting to Railway endpoint... (Add pagination here)
    // Example: GET /ideas?page=1&limit=20
    try {
      final response = await _apiClient.get('/ideas');
      final apiResponse = ApiResponse<List<IdeaCardModel>>.fromJson(
        response,
        (json) => (json as List)
            .map((e) => IdeaCardModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      final remoteIdeas = apiResponse.data ?? [];
      await LocalStorageService.saveIdeasList(remoteIdeas);
      return remoteIdeas;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      return await LocalStorageService.loadIdeasList() ?? [];
    }
  }

  @override
  Future<IdeaCardModel> createIdea(IdeaCardModel idea) async {
    // TODO: Connecting to Railway endpoint...
    // Example: POST /ideas
    try {
      final response = await _apiClient.post(
        '/ideas',
        body: idea.toJson(),
      );

      final apiResponse = ApiResponse<IdeaCardModel>.fromJson(
        response,
        (json) => IdeaCardModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) throw Exception('Failed to parse created idea.');
      final created = apiResponse.data!;
      final current = await LocalStorageService.loadIdeasList() ?? [];
      await LocalStorageService.saveIdeasList([created, ...current]);
      return created;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      final localIdea = idea.copyWith(
        id: idea.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: idea.timestamp ?? DateTime.now(),
      );
      final current = await LocalStorageService.loadIdeasList() ?? [];
      await LocalStorageService.saveIdeasList([localIdea, ...current]);
      return localIdea;
    }
  }

  @override
  Future<IdeaCardModel> updateIdea(IdeaCardModel idea) async {
    // TODO: Connecting to Railway endpoint...
    // Example: PUT /ideas/${idea.id}
    try {
      final response = await _apiClient.put(
        '/ideas/${idea.id}',
        body: idea.toJson(),
      );

      final apiResponse = ApiResponse<IdeaCardModel>.fromJson(
        response,
        (json) => IdeaCardModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) throw Exception('Failed to parse updated idea.');
      final updated = apiResponse.data!;
      final current = await LocalStorageService.loadIdeasList() ?? [];
      final idx = current.indexWhere((i) => i.id == updated.id);
      if (idx != -1) current[idx] = updated;
      await LocalStorageService.saveIdeasList(current);
      return updated;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      final current = await LocalStorageService.loadIdeasList() ?? [];
      final idx = current.indexWhere((i) => i.id == idea.id);
      if (idx != -1) {
        current[idx] = idea;
        await LocalStorageService.saveIdeasList(current);
      }
      return idea;
    }
  }

  @override
  Future<void> deleteIdea(String id) async {
    // TODO: Connecting to Railway endpoint...
    // Example: DELETE /ideas/$id
    try {
      await _apiClient.delete('/ideas/$id');
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      // Fallback to local-only delete below.
    }
    final current = await LocalStorageService.loadIdeasList() ?? [];
    current.removeWhere((idea) => idea.id == id);
    await LocalStorageService.saveIdeasList(current);
  }

  bool _shouldFallbackToLocal(Object error) {
    if (error is AuthException || error is NotFoundException) {
      return false;
    }

    if (error is NetworkException && error.statusCode != null) {
      return false;
    }

    return true;
  }
}
