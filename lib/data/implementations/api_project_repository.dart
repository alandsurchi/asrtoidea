import '../../domain/models/project_card_model.dart';
import '../../domain/repositories/project_repository.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';
import '../../services/local_storage_service.dart';
import '../../core/errors/app_exception.dart';

/// Network implementation of [ProjectRepository].
class ApiProjectRepository implements ProjectRepository {
  final ApiClient _apiClient;

  ApiProjectRepository(this._apiClient);

  @override
  Future<List<ProjectCardModel>> getProjects() async {
    // TODO: Connecting to Railway endpoint...
    // Example: GET /projects
    try {
      final response = await _apiClient.get('/projects');

      // Using ApiResponse structure mapping
      final apiResponse = ApiResponse<List<ProjectCardModel>>.fromJson(
        response,
        (json) => (json as List)
            .map((e) => ProjectCardModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      final remoteProjects = apiResponse.data ?? [];
      await LocalStorageService.saveProjectsList(remoteProjects);
      return remoteProjects;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      return await LocalStorageService.loadProjectsList() ?? [];
    }
  }

  @override
  Future<ProjectCardModel> createProject(ProjectCardModel project) async {
    // TODO: Connecting to Railway endpoint...
    // Example: POST /projects
    try {
      final response = await _apiClient.post(
        '/projects',
        body: project.toJson(),
      );

      final apiResponse = ApiResponse<ProjectCardModel>.fromJson(
        response,
        (json) => ProjectCardModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw Exception('Failed to parse created project.');
      }

      final created = apiResponse.data!;
      final current = await LocalStorageService.loadProjectsList() ?? [];
      await LocalStorageService.saveProjectsList([created, ...current]);
      return created;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      final localProject = project.copyWith(
        id: project.id?.isNotEmpty == true
            ? project.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
      );
      final current = await LocalStorageService.loadProjectsList() ?? [];
      await LocalStorageService.saveProjectsList([localProject, ...current]);
      return localProject;
    }
  }

  @override
  Future<ProjectCardModel> toggleSave(String projectId, bool isSaved) async {
    // TODO: Connecting to Railway endpoint...
    // Example: PUT /projects/$projectId/save
    try {
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

      final updated = apiResponse.data!;
      final current = await LocalStorageService.loadProjectsList() ?? [];
      final idx = current.indexWhere((p) => p.id == updated.id);
      if (idx != -1) current[idx] = updated;
      await LocalStorageService.saveProjectsList(current);
      return updated;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      final current = await LocalStorageService.loadProjectsList() ?? [];
      final idx = current.indexWhere((p) => p.id == projectId);
      if (idx == -1) throw Exception('Project not found: $projectId');
      final updated = current[idx].copyWith(isSaved: isSaved);
      current[idx] = updated;
      await LocalStorageService.saveProjectsList(current);
      return updated;
    }
  }

  @override
  Future<ProjectCardModel> toggleLike(String projectId, bool isLiked) async {
    try {
      final response = await _apiClient.put(
        '/projects/$projectId/like',
        body: {'isLiked': isLiked},
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response,
        (json) => (json as Map).map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      );

      final likePayload = apiResponse.data ?? <String, dynamic>{};
      final resolvedLiked = likePayload['isLiked'] == true;
      final resolvedLikeCount = _toInt(likePayload['likeCount']);

      final current = await LocalStorageService.loadProjectsList() ?? [];
      final idx = current.indexWhere((p) => p.id == projectId);

      if (idx != -1) {
        final updated = current[idx].copyWith(
          isLiked: resolvedLiked,
          likeCount: resolvedLikeCount,
        );
        current[idx] = updated;
        await LocalStorageService.saveProjectsList(current);
        return updated;
      }

      final fullResponse = await _apiClient.get('/projects/$projectId');
      final fullParsed = ApiResponse<ProjectCardModel>.fromJson(
        fullResponse,
        (json) => ProjectCardModel.fromJson(json as Map<String, dynamic>),
      );

      if (fullParsed.data == null) {
        throw Exception('Failed to resolve liked project after update.');
      }

      final fetched = fullParsed.data!;
      await LocalStorageService.saveProjectsList([fetched, ...current]);
      return fetched;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      final current = await LocalStorageService.loadProjectsList() ?? [];
      final idx = current.indexWhere((p) => p.id == projectId);
      if (idx == -1) throw Exception('Project not found: $projectId');

      final previousCount = current[idx].likeCount ?? 0;
      final optimisticCount = isLiked
          ? previousCount + 1
          : (previousCount > 0 ? previousCount - 1 : 0);

      final updated = current[idx].copyWith(
        isLiked: isLiked,
        likeCount: optimisticCount,
      );
      current[idx] = updated;
      await LocalStorageService.saveProjectsList(current);
      return updated;
    }
  }

  @override
  Future<ProjectCardModel> addComment(String projectId, String comment) async {
    // TODO: Connecting to Railway endpoint...
    // Example: POST /projects/$projectId/comments
    try {
      final response = await _apiClient.post(
        '/projects/$projectId/comments',
        body: {'comment': comment},
      );

      final dynamic rawData = response['data'];
      if (rawData is Map<String, dynamic>) {
        final apiResponse = ApiResponse<ProjectCardModel>.fromJson(
          response,
          (json) => ProjectCardModel.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.data == null) {
          throw Exception('Failed to parse commented project.');
        }

        final updated = apiResponse.data!;
        final current = await LocalStorageService.loadProjectsList() ?? [];
        final idx = current.indexWhere((p) => p.id == updated.id);
        if (idx != -1) current[idx] = updated;
        await LocalStorageService.saveProjectsList(current);
        return updated;
      }

      // Thread API may return comment list for detail flows; keep explore behavior by
      // applying an optimistic local append when project payload is not returned.
      final current = await LocalStorageService.loadProjectsList() ?? [];
      final idx = current.indexWhere((p) => p.id == projectId);
      if (idx == -1) throw Exception('Project not found: $projectId');
      final updatedComments = [
        ...(current[idx].comments ?? <String>[]),
        comment.trim(),
      ];
      final updated = current[idx].copyWith(comments: updatedComments);
      current[idx] = updated;
      await LocalStorageService.saveProjectsList(current);
      return updated;
    } catch (e) {
      if (!_shouldFallbackToLocal(e)) rethrow;
      final current = await LocalStorageService.loadProjectsList() ?? [];
      final idx = current.indexWhere((p) => p.id == projectId);
      if (idx == -1) throw Exception('Project not found: $projectId');
      final updatedComments = [
        ...(current[idx].comments ?? <String>[]),
        comment.trim(),
      ];
      final updated = current[idx].copyWith(comments: updatedComments);
      current[idx] = updated;
      await LocalStorageService.saveProjectsList(current);
      return updated;
    }
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

  int _toInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }
}
