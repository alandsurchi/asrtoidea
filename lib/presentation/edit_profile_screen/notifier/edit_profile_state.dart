part of 'edit_profile_notifier.dart';

class EditProfileState extends Equatable {
  final bool? isLoading;
  final bool? isSuccess;
  final String? errorMessage;
  final EditProfileModel? editProfileModel;

  EditProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.editProfileModel,
  });

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    errorMessage,
    editProfileModel,
  ];

  EditProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    EditProfileModel? editProfileModel,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      editProfileModel: editProfileModel ?? this.editProfileModel,
    );
  }
}
