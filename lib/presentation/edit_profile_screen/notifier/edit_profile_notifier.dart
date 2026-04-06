import 'package:ai_idea_generator/domain/models/edit_profile_model.dart';
import 'package:ai_idea_generator/domain/models/user_profile.dart';
import 'package:ai_idea_generator/domain/repositories/auth_repository.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/settings_model.dart';

part 'edit_profile_state.dart';

final editProfileNotifier =
    StateNotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
      (ref) => EditProfileNotifier(
        EditProfileState(editProfileModel: EditProfileModel()),
        ref.read(authRepositoryProvider),
      ),
    );

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final AuthRepository _repository;

  EditProfileNotifier(EditProfileState state, this._repository) : super(state);

  void initialize(SettingsModel? currentSettings) {
    state = state.copyWith(
      editProfileModel: state.editProfileModel?.copyWith(
        fullName: currentSettings?.userName ?? state.editProfileModel?.fullName,
        email: currentSettings?.userEmail ?? state.editProfileModel?.email,
        profileImagePath: currentSettings?.profileImagePath ?? state.editProfileModel?.profileImagePath,
      ),
      isLoading: false,
    );
  }

  void updateFullName(String fullName) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(fullName: fullName));

  void updateNickName(String nickName) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(nickName: nickName));

  void updateEmail(String email) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(email: email));

  void updatePhone(String phone) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(phone: phone));

  void updateAddress(String address) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(address: address));

  void updateJob(String job) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(job: job));

  void updateProfileImage(String imagePath) =>
      state = state.copyWith(editProfileModel: state.editProfileModel?.copyWith(profileImagePath: imagePath));

  Future<void> saveProfile() async {
    if (state.isLoading ?? false) return;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final model = state.editProfileModel;
      final profile = UserProfile(
        id: '',
        name: model?.fullName ?? '',
        email: model?.email ?? '',
        profileImagePath: model?.profileImagePath,
        nickName: model?.nickName,
        phone: model?.phone,
        address: model?.address,
        job: model?.job,
      );

      await _repository.updateUserProfile(profile);
      state = state.copyWith(isLoading: false, isSuccess: true);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) state = state.copyWith(isSuccess: false);
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('Exception:')
            ? e.toString().split('Exception: ').last
            : 'Failed to save profile. Please try again.',
      );
    }
  }
}
