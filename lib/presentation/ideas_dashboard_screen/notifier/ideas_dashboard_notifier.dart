import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/ideas_dashboard_model.dart';
import 'package:ai_idea_generator/domain/repositories/idea_repository.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import 'package:ai_idea_generator/core/utils/filter_utils.dart';
import 'package:ai_idea_generator/core/errors/app_exception.dart';

part 'ideas_dashboard_state.dart';

final ideasDashboardNotifier =
    StateNotifierProvider<IdeasDashboardNotifier, IdeasDashboardState>(
      (ref) => IdeasDashboardNotifier(
        IdeasDashboardState(ideasDashboardModel: IdeasDashboardModel()),
        ref.read(ideaRepositoryProvider),
      ),
    );

class IdeasDashboardNotifier extends StateNotifier<IdeasDashboardState> {
  final IdeaRepository _repository;

  IdeasDashboardNotifier(IdeasDashboardState state, this._repository)
      : super(state) {
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    state = state.copyWith(isLoading: true);
    try {
      final ideas = await _repository.getIdeas();
      state = state.copyWith(
        ideasDashboardModel: IdeasDashboardModel(
          ideaCardsList: ideas,
          allIdeasList: ideas,
          additionalIdeasList: ideas,
        ),
        isLoading: false,
        selectedFilterIndex: 0,
        currentCarouselIndex: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: appErrorMessage(e));
    }
  }

  void onSearchChanged(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void updateSelectedFilter(int index) {
    state = state.copyWith(selectedFilterIndex: index);
    _applyFilters();
  }

  void updateCarouselIndex(int index) {
    state = state.copyWith(currentCarouselIndex: index);
  }

  void toggleFilterOptions() {
    state = state.copyWith(showFilterOptions: !(state.showFilterOptions ?? false));
  }

  void _applyFilters() {
    final query = (state.searchQuery ?? '').toLowerCase();
    final targetStatus = FilterUtils.statusForTabIndex(state.selectedFilterIndex ?? 0);
    final allIdeas = state.ideasDashboardModel?.allIdeasList ?? [];

    final filtered = allIdeas.where((idea) {
      final matchesStatus = targetStatus == null || idea.status == targetStatus;
      final matchesSearch = query.isEmpty ||
          (idea.title?.toLowerCase().contains(query) ?? false) ||
          (idea.category?.toLowerCase().contains(query) ?? false);
      return matchesStatus && matchesSearch;
    }).toList();

    state = state.copyWith(
      ideasDashboardModel: state.ideasDashboardModel?.copyWith(
        additionalIdeasList: filtered,
      ),
    );
  }
}
