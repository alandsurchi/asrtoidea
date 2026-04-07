import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/project_card_model.dart';
import 'package:ai_idea_generator/domain/models/project_explore_dashboard_model.dart';
import 'package:ai_idea_generator/domain/models/project_filter_tab_model.dart';
import 'package:ai_idea_generator/domain/repositories/project_repository.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import 'package:ai_idea_generator/core/utils/filter_utils.dart';
import 'package:ai_idea_generator/core/errors/app_exception.dart';

part 'project_explore_dashboard_state.dart';

final projectExploreDashboardNotifier =
    StateNotifierProvider<ProjectExploreDashboardNotifier, ProjectExploreDashboardState>(
      (ref) => ProjectExploreDashboardNotifier(
        ProjectExploreDashboardState(
          projectExploreDashboardModel: ProjectExploreDashboardModel(),
        ),
        ref.read(projectRepositoryProvider),
      ),
    );

class ProjectExploreDashboardNotifier
    extends StateNotifier<ProjectExploreDashboardState> {
  final ProjectRepository _repository;

  ProjectExploreDashboardNotifier(
    ProjectExploreDashboardState state,
    this._repository,
  ) : super(state) {
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    state = state.copyWith(isLoading: true);
    try {
      final projects = await _repository.getProjects();
      state = state.copyWith(
        isLoading: false,
        selectedTabIndex: 0,
        projectExploreDashboardModel: ProjectExploreDashboardModel(
          filterTabs: [
            ProjectFilterTabModel(title: 'In progress', count: 10),
            ProjectFilterTabModel(title: 'To-do', count: 10),
            ProjectFilterTabModel(title: 'Completed', count: 10),
            ProjectFilterTabModel(title: 'Generated', count: 10),
          ],
          projectCards: projects,
          allProjectCards: projects,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: appErrorMessage(e));
    }
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void insertGeneratedProject(ProjectCardModel project) {
    final currentModel =
        state.projectExploreDashboardModel ?? ProjectExploreDashboardModel();
    final allCards =
        List<ProjectCardModel>.from(currentModel.allProjectCards ?? []);

    allCards.removeWhere((item) => item.id == project.id);
    allCards.insert(0, project);

    state = state.copyWith(
      selectedTabIndex: 0,
      searchQuery: '',
      projectExploreDashboardModel: currentModel.copyWith(
        projectCards: allCards,
        allProjectCards: allCards,
      ),
    );
    _applyFilters();
  }

  void _applyFilters() {
    final query = (state.searchQuery ?? '').toLowerCase();
    final targetStatus = FilterUtils.statusForTabIndex(state.selectedTabIndex ?? 0);
    final allCards = state.projectExploreDashboardModel?.allProjectCards ?? [];

    final filtered = allCards.where((card) {
      final matchesStatus = targetStatus == null || card.statusText == targetStatus;
      final matchesSearch = query.isEmpty ||
          (card.title?.toLowerCase().contains(query) ?? false) ||
          (card.description?.toLowerCase().contains(query) ?? false);
      return matchesStatus && matchesSearch;
    }).toList();

    state = state.copyWith(
      projectExploreDashboardModel: state.projectExploreDashboardModel?.copyWith(
        projectCards: filtered,
      ),
    );
  }

  Future<void> toggleSave(String projectId) async {
    final allCards = List<ProjectCardModel>.from(
      state.projectExploreDashboardModel?.allProjectCards ?? [],
    );
    final index = allCards.indexWhere((c) => c.id == projectId);
    if (index == -1) return;

    final isCurrentlySaved = allCards[index].isSaved ?? false;
    try {
      final updated = await _repository.toggleSave(projectId, !isCurrentlySaved);
      allCards[index] = updated;
    } catch (_) {
      // Optimistic update fallback
      allCards[index] = allCards[index].copyWith(isSaved: !isCurrentlySaved);
    }

    state = state.copyWith(
      projectExploreDashboardModel: state.projectExploreDashboardModel?.copyWith(
        allProjectCards: allCards,
      ),
    );
    _applyFilters();
  }

  Future<void> addComment(String projectId, String commentText) async {
    if (commentText.trim().isEmpty) return;

    final allCards = List<ProjectCardModel>.from(
      state.projectExploreDashboardModel?.allProjectCards ?? [],
    );
    final index = allCards.indexWhere((c) => c.id == projectId);
    if (index == -1) return;

    try {
      final updated = await _repository.addComment(projectId, commentText);
      allCards[index] = updated;
    } catch (_) {
      // Optimistic update fallback
      final comments = [...(allCards[index].comments ?? <String>[]), commentText.trim()];
      allCards[index] = allCards[index].copyWith(comments: comments);
    }

    state = state.copyWith(
      projectExploreDashboardModel: state.projectExploreDashboardModel?.copyWith(
        allProjectCards: allCards,
      ),
    );
    _applyFilters();
  }

  Future<void> refreshProjects() async {
    state = state.copyWith(isLoading: true);
    try {
      final projects = await _repository.getProjects();
      final current = state.projectExploreDashboardModel;
      state = state.copyWith(
        isLoading: false,
        projectExploreDashboardModel: current?.copyWith(
          projectCards: projects,
          allProjectCards: projects,
        ),
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}
