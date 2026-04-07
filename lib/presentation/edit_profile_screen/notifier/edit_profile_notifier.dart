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

  Future<void> initialize(SettingsModel? currentSettings) async {
    final current = state.editProfileModel ?? EditProfileModel();
    final seededProfileImagePath = _sanitizeProfileImagePath(
      currentSettings?.profileImagePath ?? current.profileImagePath,
    );

    state = state.copyWith(
      editProfileModel: current.copyWith(
        fullName: currentSettings?.userName ?? current.fullName,
        email: currentSettings?.userEmail ?? current.email,
        profileImagePath: seededProfileImagePath,
      ),
      isLoading: true,
      errorMessage: null,
    );

    try {
      final remote = await _repository.getUserProfile();
      final remoteProfileImagePath = _sanitizeProfileImagePath(
        remote.profileImagePath,
      );

      state = state.copyWith(
        editProfileModel: (state.editProfileModel ?? EditProfileModel()).copyWith(
          id: remote.id,
          profileImagePath: remoteProfileImagePath ?? seededProfileImagePath,
          fullName: remote.name,
          nickName: remote.nickName ?? '',
          email: remote.email,
          phone: remote.phone ?? '',
          address: remote.address ?? '',
          job: remote.job ?? '',
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().contains('Exception:')
            ? e.toString().split('Exception: ').last
            : null,
      );
    }
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
      final normalizedProfileImagePath = _sanitizeProfileImagePath(
        model?.profileImagePath,
      );
      final profile = UserProfile(
        id: model?.id ?? '',
        name: model?.fullName ?? '',
        email: model?.email ?? '',
        profileImagePath: normalizedProfileImagePath,
        nickName: model?.nickName,
        phone: model?.phone,
        address: model?.address,
        job: model?.job,
      );

      final updated = await _repository.updateUserProfile(profile);
      state = state.copyWith(
        editProfileModel: (state.editProfileModel ?? EditProfileModel()).copyWith(
          id: updated.id,
          profileImagePath: _sanitizeProfileImagePath(updated.profileImagePath),
          fullName: updated.name,
          nickName: updated.nickName ?? '',
          email: updated.email,
          phone: updated.phone ?? '',
          address: updated.address ?? '',
          job: updated.job ?? '',
        ),
        isLoading: false,
        isSuccess: true,
      );

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

  String? _sanitizeProfileImagePath(String? imagePath) {
    final value = imagePath?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    final legacyPlaceholders = <String>{
      ImageConstant.imgUserProfilePhoto,
      ImageConstant.imgImage,
      ImageConstant.imgImage176x160,
    };

    if (legacyPlaceholders.contains(value)) {
      return null;
    }

    return value;
  }
}
