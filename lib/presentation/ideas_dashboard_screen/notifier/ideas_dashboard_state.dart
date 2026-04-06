part of 'ideas_dashboard_notifier.dart';

class IdeasDashboardState extends Equatable {
  final IdeasDashboardModel? ideasDashboardModel;
  final bool? isLoading;
  final String? errorMessage;
  final String? searchQuery;
  final int? selectedFilterIndex;
  final int? currentCarouselIndex;
  final bool? showFilterOptions;

  IdeasDashboardState({
    this.ideasDashboardModel,
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedFilterIndex = 0,
    this.currentCarouselIndex = 0,
    this.showFilterOptions = false,
  });

  @override
  List<Object?> get props => [
    ideasDashboardModel,
    isLoading,
    errorMessage,
    searchQuery,
    selectedFilterIndex,
    currentCarouselIndex,
    showFilterOptions,
  ];

  IdeasDashboardState copyWith({
    IdeasDashboardModel? ideasDashboardModel,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    int? selectedFilterIndex,
    int? currentCarouselIndex,
    bool? showFilterOptions,
  }) {
    return IdeasDashboardState(
      ideasDashboardModel: ideasDashboardModel ?? this.ideasDashboardModel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      currentCarouselIndex: currentCarouselIndex ?? this.currentCarouselIndex,
      showFilterOptions: showFilterOptions ?? this.showFilterOptions,
    );
  }
}
