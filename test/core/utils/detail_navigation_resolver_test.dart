import 'package:flutter_test/flutter_test.dart';
import 'package:ai_idea_generator/core/utils/detail_navigation_resolver.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';

void main() {
  group('resolveIdeaDetailTarget', () {
    test('routes to linked project detail when linkedProjectId exists', () {
      final idea = IdeaCardModel(
        id: 'idea-1',
        linkedProjectId: 'project-99',
      );

      final target = resolveIdeaDetailTarget(idea);

      expect(target.entityType, 'project');
      expect(target.id, 'project-99');
    });

    test('routes to idea detail when no linked project exists', () {
      final idea = IdeaCardModel(
        id: 'idea-1',
        linkedProjectId: '',
      );

      final target = resolveIdeaDetailTarget(idea);

      expect(target.entityType, 'idea');
      expect(target.id, 'idea-1');
    });
  });
}
