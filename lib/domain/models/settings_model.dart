import '../../../core/app_export.dart';
import 'user_profile.dart';

/// This class is used in the [settings_screen] screen.

// ignore_for_file: must_be_immutable
class SettingsModel extends Equatable {
  SettingsModel({
    this.userName,
    this.userEmail,
    this.profileImagePath,
    this.isDarkMode,
    this.isLoading,
    this.id,
  }) {
    userName = userName ?? "Guest User";
    userEmail = userEmail ?? "Not signed in";
    profileImagePath = profileImagePath ?? ImageConstant.imgUserProfilePhoto;
    isDarkMode = isDarkMode ?? false;
    isLoading = isLoading ?? false;
    id = id ?? "";
  }

  String? userName;
  String? userEmail;
  String? profileImagePath;
  bool? isDarkMode;
  bool? isLoading;
  String? id;

  SettingsModel copyWith({
    String? userName,
    String? userEmail,
    String? profileImagePath,
    bool? isDarkMode,
    bool? isLoading,
    String? id,
  }) {
    return SettingsModel(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isLoading: isLoading ?? this.isLoading,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    userEmail,
    profileImagePath,
    isDarkMode,
    isLoading,
    id,
  ];

  /// Serializes to JSON (for local persistence only — UI fields excluded).
  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'userEmail': userEmail,
    'profileImagePath': profileImagePath,
  };

  /// Deserializes from JSON (local storage only).
  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    id: json['id'] as String?,
    userName: json['userName'] as String?,
    userEmail: json['userEmail'] as String?,
    profileImagePath: json['profileImagePath'] as String?,
  );

  /// Creates a [SettingsModel] from a [UserProfile] returned by the backend.
  /// Preserves existing UI flags (isDarkMode, isLoading) from [current].
  factory SettingsModel.fromUserProfile(
    UserProfile profile, {
    SettingsModel? current,
  }) =>
      SettingsModel(
        id: profile.id,
        userName: profile.name,
        userEmail: profile.email,
        profileImagePath: profile.profileImagePath,
        isDarkMode: current?.isDarkMode ?? false,
        isLoading: false,
      );

  factory SettingsModel.guest({SettingsModel? current}) => SettingsModel(
    id: '',
    userName: 'Guest User',
    userEmail: 'Not signed in',
    profileImagePath: current?.profileImagePath ?? ImageConstant.imgUserProfilePhoto,
    isDarkMode: current?.isDarkMode ?? false,
    isLoading: false,
  );
}

