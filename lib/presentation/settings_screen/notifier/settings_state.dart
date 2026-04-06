part of 'settings_notifier.dart';

class SettingsState extends Equatable {
  final SettingsModel? settingsModel;
  final bool? isLoading;
  final bool? isSuccess;

  SettingsState({
    this.settingsModel,
    this.isLoading = false,
    this.isSuccess = false,
  });

  @override
  List<Object?> get props => [settingsModel, isLoading, isSuccess];

  SettingsState copyWith({
    SettingsModel? settingsModel,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return SettingsState(
      settingsModel: settingsModel ?? this.settingsModel,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
