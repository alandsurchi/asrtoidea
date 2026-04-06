import '../../../core/app_export.dart';
import './project_card_model.dart';
import './project_filter_tab_model.dart';

/// This class is used in the [project_explore_dashboard_screen] screen.

// ignore_for_file: must_be_immutable
class ProjectExploreDashboardModel extends Equatable {
  ProjectExploreDashboardModel({this.filterTabs, this.projectCards, this.allProjectCards}) {
    filterTabs = filterTabs ?? [];
    projectCards = projectCards ?? [];
    allProjectCards = allProjectCards ?? [];
  }

  List<ProjectFilterTabModel>? filterTabs;
  List<ProjectCardModel>? projectCards;
  List<ProjectCardModel>? allProjectCards;

  ProjectExploreDashboardModel copyWith({
    List<ProjectFilterTabModel>? filterTabs,
    List<ProjectCardModel>? projectCards,
    List<ProjectCardModel>? allProjectCards,
  }) {
    return ProjectExploreDashboardModel(
      filterTabs: filterTabs ?? this.filterTabs,
      projectCards: projectCards ?? this.projectCards,
      allProjectCards: allProjectCards ?? this.allProjectCards,
    );
  }

  @override
  List<Object?> get props => [filterTabs, projectCards, allProjectCards];
}
