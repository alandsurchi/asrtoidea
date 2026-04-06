import '../../domain/models/ideas_dashboard_model.dart';
import '../../domain/repositories/idea_repository.dart';
import '../../data/repositories/mock_repository.dart';
import '../../services/local_storage_service.dart';

/// Mock implementation of [IdeaRepository].
///
/// Data source priority:
///   1. LocalStorage (persisted across restarts)
///   2. MockRepository.mockIdeas (first-run seed data)
///
/// Replace this class with [FirebaseIdeaRepository] when ready.
class MockIdeaRepository implements IdeaRepository {
  // In-memory list mutated by CRUD operations.
  List<IdeaCardModel>? _cache;

  Future<List<IdeaCardModel>> _ensureLoaded() async {
    if (_cache != null) return _cache!;
    _cache = await LocalStorageService.loadIdeasList() ?? MockRepository.mockIdeas;
    return _cache!;
  }

  @override
  Future<List<IdeaCardModel>> getIdeas() => _ensureLoaded();

  @override
  Future<IdeaCardModel> createIdea(IdeaCardModel idea) async {
    final ideas = await _ensureLoaded();
    final newIdea = idea.copyWith(
      id: idea.id?.isNotEmpty == true
          ? idea.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: idea.timestamp ?? DateTime.now(),
    );
    _cache = [newIdea, ...ideas];
    await LocalStorageService.saveIdeasList(_cache!);
    return newIdea;
  }

  @override
  Future<IdeaCardModel> updateIdea(IdeaCardModel idea) async {
    final ideas = await _ensureLoaded();
    final index = ideas.indexWhere((i) => i.id == idea.id);
    if (index == -1) throw Exception('Idea not found: ${idea.id}');
    final updated = List<IdeaCardModel>.from(ideas);
    updated[index] = idea;
    _cache = updated;
    await LocalStorageService.saveIdeasList(_cache!);
    return idea;
  }

  @override
  Future<void> deleteIdea(String id) async {
    final ideas = await _ensureLoaded();
    _cache = ideas.where((i) => i.id != id).toList();
    await LocalStorageService.saveIdeasList(_cache!);
  }
}
