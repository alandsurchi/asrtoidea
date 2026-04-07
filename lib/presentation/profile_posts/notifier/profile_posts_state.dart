part of 'profile_posts_notifier.dart';

class ProfilePostsState extends Equatable {
  final List<ProjectCardModel> posts;
  final bool isLoading;
  final String? errorMessage;

  const ProfilePostsState({
    this.posts = const <ProjectCardModel>[],
    this.isLoading = false,
    this.errorMessage,
  });

  ProfilePostsState copyWith({
    List<ProjectCardModel>? posts,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfilePostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [posts, isLoading, errorMessage];
}
