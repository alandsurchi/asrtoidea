part of 'project_explore_dashboard_notifier.dart';

class ProjectExploreDashboardState extends Equatable {
  final bool? isLoading;
  final String? errorMessage;
  final int? selectedTabIndex;
  final String? searchQuery;
  final ProjectExploreDashboardModel? projectExploreDashboardModel;

  ProjectExploreDashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.selectedTabIndex = 0,
    this.searchQuery = '',
    this.projectExploreDashboardModel,
  });

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    selectedTabIndex,
    searchQuery,
    projectExploreDashboardModel,
  ];

  ProjectExploreDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? selectedTabIndex,
    String? searchQuery,
    ProjectExploreDashboardModel? projectExploreDashboardModel,
  }) {
    return ProjectExploreDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      projectExploreDashboardModel:
          projectExploreDashboardModel ?? this.projectExploreDashboardModel,
    );
  }
}
