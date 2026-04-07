import '../../domain/models/project_card_model.dart';
import '../../domain/repositories/project_repository.dart';
import '../../data/repositories/mock_repository.dart';
import '../../services/local_storage_service.dart';

/// Mock implementation of [ProjectRepository].
/// Replace with [FirebaseProjectRepository] when backend is ready.
class MockProjectRepository implements ProjectRepository {
  // In-memory state for the session.
  List<ProjectCardModel>? _cache;

  Future<List<ProjectCardModel>> _ensureLoaded() async {
    _cache ??= await LocalStorageService.loadProjectsList() ?? MockRepository.mockProjects;
    return _cache!;
  }

  @override
  Future<List<ProjectCardModel>> getProjects() => _ensureLoaded();

  @override
  Future<ProjectCardModel> createProject(ProjectCardModel project) async {
    final projects = await _ensureLoaded();
    final localProject = project.copyWith(
      id: project.id?.isNotEmpty == true
          ? project.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _cache = [localProject, ...projects];
    await LocalStorageService.saveProjectsList(_cache!);
    return localProject;
  }

  @override
  Future<ProjectCardModel> toggleSave(String projectId, bool isSaved) async {
    final projects = await _ensureLoaded();
    final index = projects.indexWhere((p) => p.id == projectId);
    if (index == -1) throw Exception('Project not found: $projectId');
    final updated = projects[index].copyWith(isSaved: isSaved);
    _cache = List<ProjectCardModel>.from(projects)..[index] = updated;
    await LocalStorageService.saveProjectsList(_cache!);
    return updated;
  }

  @override
  Future<ProjectCardModel> addComment(String projectId, String comment) async {
    if (comment.trim().isEmpty) throw Exception('Comment cannot be empty');
    final projects = await _ensureLoaded();
    final index = projects.indexWhere((p) => p.id == projectId);
    if (index == -1) throw Exception('Project not found: $projectId');
    final existing = projects[index];
    final updatedComments = [...(existing.comments ?? <String>[]), comment.trim()];
    final updated = existing.copyWith(comments: updatedComments);
    _cache = List<ProjectCardModel>.from(projects)..[index] = updated;
    await LocalStorageService.saveProjectsList(_cache!);
    return updated;
  }
}
