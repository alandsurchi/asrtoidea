import '../../../core/app_export.dart';

/// This class is used in the [edit_profile_screen] screen.

// ignore_for_file: must_be_immutable
class EditProfileModel extends Equatable {
  EditProfileModel({
    this.profileImagePath,
    this.fullName,
    this.nickName,
    this.email,
    this.phone,
    this.address,
    this.job,
    this.id,
  }) {
    profileImagePath = profileImagePath ?? "";
    fullName = fullName ?? "";
    nickName = nickName ?? "";
    email = email ?? "";
    phone = phone ?? "";
    address = address ?? "";
    job = job ?? "";
    id = id ?? "";
  }

  String? profileImagePath;
  String? fullName;
  String? nickName;
  String? email;
  String? phone;
  String? address;
  String? job;
  String? id;

  EditProfileModel copyWith({
    String? profileImagePath,
    String? fullName,
    String? nickName,
    String? email,
    String? phone,
    String? address,
    String? job,
    String? id,
  }) {
    return EditProfileModel(
      profileImagePath: profileImagePath ?? this.profileImagePath,
      fullName: fullName ?? this.fullName,
      nickName: nickName ?? this.nickName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      job: job ?? this.job,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    profileImagePath,
    fullName,
    nickName,
    email,
    phone,
    address,
    job,
    id,
  ];
}
