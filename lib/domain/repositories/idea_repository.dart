import '../../domain/models/ideas_dashboard_model.dart';

/// Contract defining all idea-related data operations.
/// The UI layer only depends on this interface — never on a concrete class.
/// To connect Firebase: implement this with [FirebaseIdeaRepository].
abstract class IdeaRepository {
  /// Returns the full list of ideas, from cache or remote.
  Future<List<IdeaCardModel>> getIdeas();

  /// Persists [idea] and returns the saved copy (may include server-assigned id).
  Future<IdeaCardModel> createIdea(IdeaCardModel idea);

  /// Updates an existing idea. Identified by [idea.id].
  Future<IdeaCardModel> updateIdea(IdeaCardModel idea);

  /// Removes the idea with the given [id].
  Future<void> deleteIdea(String id);
}
