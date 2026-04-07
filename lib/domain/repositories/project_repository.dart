import '../../domain/models/project_card_model.dart';

/// Contract defining all project explore data operations.
abstract class ProjectRepository {
  /// Returns all project cards.
  Future<List<ProjectCardModel>> getProjects();

  /// Creates a new project card and returns the persisted record.
  Future<ProjectCardModel> createProject(ProjectCardModel project);

  /// Toggles the saved state of project [projectId].
  Future<ProjectCardModel> toggleSave(String projectId, bool isSaved);

  /// Toggles the liked state of project [projectId].
  Future<ProjectCardModel> toggleLike(String projectId, bool isLiked);

  /// Appends [comment] to the project's comment list.
  Future<ProjectCardModel> addComment(String projectId, String comment);
}
