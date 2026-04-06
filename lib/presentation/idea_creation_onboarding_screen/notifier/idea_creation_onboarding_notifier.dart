import 'package:ai_idea_generator/domain/models/idea_creation_onboarding_model.dart';
import '../../../core/app_export.dart';

part 'idea_creation_onboarding_state.dart';

final ideaCreationOnboardingNotifier =
    StateNotifierProvider.autoDispose<
      IdeaCreationOnboardingNotifier,
      IdeaCreationOnboardingState
    >(
      (ref) => IdeaCreationOnboardingNotifier(
        IdeaCreationOnboardingState(
          ideaCreationOnboardingModel: IdeaCreationOnboardingModel(),
        ),
      ),
    );

class IdeaCreationOnboardingNotifier
    extends StateNotifier<IdeaCreationOnboardingState> {
  IdeaCreationOnboardingNotifier(IdeaCreationOnboardingState state)
    : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      currentPageIndex: 2, // Third dot is active (0-based index)
      totalPages: 3,
    );
  }

  void updatePageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }
}
