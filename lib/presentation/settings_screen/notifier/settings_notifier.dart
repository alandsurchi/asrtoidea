import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/settings_model.dart';
import 'package:ai_idea_generator/services/local_storage_service.dart';
import 'dart:developer' as dev;

part 'settings_state.dart';

final settingsNotifier = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(SettingsState(settingsModel: SettingsModel())),
);

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(SettingsState state) : super(state) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final saved = await LocalStorageService.loadProfile();
      state = state.copyWith(
        settingsModel: saved ??
            SettingsModel(
              userName: 'Aland Raed',
              userEmail: 'aland.raed.othman@gmail.com',
              profileImagePath: ImageConstant.imgUserProfilePhoto,
              isDarkMode: true,
              isLoading: false,
            ),
      );
    } catch (e) {
      dev.log('SettingsNotifier._loadProfile failed', error: e);
      // Fall back to defaults — do not crash
      state = state.copyWith(
        settingsModel: SettingsModel(
          userName: 'Aland Raed',
          userEmail: 'aland.raed.othman@gmail.com',
          profileImagePath: ImageConstant.imgUserProfilePhoto,
          isDarkMode: true,
          isLoading: false,
        ),
      );
    }
  }

  void updateDarkMode(bool value) {
    state = state.copyWith(
      settingsModel: state.settingsModel?.copyWith(isDarkMode: value),
    );
    _persistProfile();
  }

  void updateProfile(String name, String email, {String? imagePath}) {
    state = state.copyWith(
      settingsModel: state.settingsModel?.copyWith(
        userName: name,
        userEmail: email,
        profileImagePath: imagePath ?? state.settingsModel?.profileImagePath,
      ),
    );
    _persistProfile();
  }

  void updateProfileImage(String imagePath) {
    state = state.copyWith(
      settingsModel: state.settingsModel?.copyWith(profileImagePath: imagePath),
    );
    _persistProfile();
  }

  Future<void> _persistProfile() async {
    try {
      final model = state.settingsModel;
      if (model != null) await LocalStorageService.saveProfile(model);
    } catch (e) {
      dev.log('SettingsNotifier._persistProfile failed', error: e);
      // Don't surface storage errors — profile already updated in memory
    }
  }
}
