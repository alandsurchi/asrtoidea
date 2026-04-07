import '../../../core/app_export.dart';
import 'package:ai_idea_generator/domain/models/settings_model.dart';
import 'package:ai_idea_generator/domain/repositories/auth_repository.dart';
import 'package:ai_idea_generator/core/providers/repository_providers.dart';
import 'package:ai_idea_generator/services/local_storage_service.dart';
import 'dart:developer' as dev;

part 'settings_state.dart';

final settingsNotifier = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(
    SettingsState(settingsModel: SettingsModel()),
    ref.read(authRepositoryProvider),
  ),
);

class SettingsNotifier extends StateNotifier<SettingsState> {
  final AuthRepository _authRepository;

  SettingsNotifier(SettingsState state, this._authRepository) : super(state) {
    _loadProfile();
  }

  Future<void> reloadProfile() => _loadProfile();

  Future<void> _loadProfile() async {
    state = state.copyWith(isLoading: true);
    SettingsModel? saved;

    try {
      saved = await LocalStorageService.loadProfile();
      saved = _sanitizeSettingsModel(saved);
    } catch (e) {
      dev.log('SettingsNotifier.loadProfile(local) failed', error: e);
    }

    try {
      final profile = await _authRepository.getUserProfile();
      final mapped = _sanitizeSettingsModel(
        SettingsModel.fromUserProfile(
          profile,
          current: saved ?? state.settingsModel,
        ),
      );

      state = state.copyWith(
        settingsModel: mapped,
        isLoading: false,
        isSuccess: true,
      );
      await LocalStorageService.saveProfile(mapped);
    } catch (e) {
      dev.log('SettingsNotifier.loadProfile(remote) failed', error: e);
      state = state.copyWith(
        settingsModel:
            saved ?? _sanitizeSettingsModel(SettingsModel.guest(current: state.settingsModel)),
        isLoading: false,
        isSuccess: false,
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
        profileImagePath: _sanitizeProfileImagePath(
              imagePath ?? state.settingsModel?.profileImagePath,
            ) ??
            '',
      ),
    );
    _persistProfile();
  }

  void updateProfileImage(String imagePath) {
    state = state.copyWith(
      settingsModel: state.settingsModel?.copyWith(
        profileImagePath: _sanitizeProfileImagePath(imagePath) ?? '',
      ),
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

  SettingsModel _sanitizeSettingsModel(SettingsModel? model) {
    final base = model ?? SettingsModel.guest(current: state.settingsModel);
    return SettingsModel(
      id: base.id,
      userName: base.userName,
      userEmail: base.userEmail,
      profileImagePath: _sanitizeProfileImagePath(base.profileImagePath),
      isDarkMode: base.isDarkMode,
      isLoading: base.isLoading,
    );
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
