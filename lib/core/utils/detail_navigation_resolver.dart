import '../../domain/models/ideas_dashboard_model.dart';

class DetailNavigationTarget {
  final String entityType;
  final String id;

  const DetailNavigationTarget({
    required this.entityType,
    required this.id,
  });
}

DetailNavigationTarget resolveIdeaDetailTarget(IdeaCardModel idea) {
  final ideaId = (idea.id ?? '').trim();
  final linkedProjectId = (idea.linkedProjectId ?? '').trim();

  if (linkedProjectId.isNotEmpty) {
    return DetailNavigationTarget(entityType: 'project', id: linkedProjectId);
  }

  return DetailNavigationTarget(entityType: 'idea', id: ideaId);
}
