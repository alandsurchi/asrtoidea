import '../../domain/models/project_card_model.dart';

/// Contract defining all project explore data operations.
abstract class ProjectRepository {
  /// Returns all project cards.
  Future<List<ProjectCardModel>> getProjects();

  /// Toggles the saved state of project [projectId].
  Future<ProjectCardModel> toggleSave(String projectId, bool isSaved);

  /// Appends [comment] to the project's comment list.
  Future<ProjectCardModel> addComment(String projectId, String comment);
}
