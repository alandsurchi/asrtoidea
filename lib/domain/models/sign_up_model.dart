import '../../../core/app_export.dart';

/// This class is used in the [SignUpScreen] screen.

// ignore_for_file: must_be_immutable
class SignUpModel extends Equatable {
  SignUpModel({this.email, this.name, this.password, this.id}) {
    email = email ?? "";
    name = name ?? "";
    password = password ?? "";
    id = id ?? "";
  }

  String? email;
  String? name;
  String? password;
  String? id;

  SignUpModel copyWith({
    String? email,
    String? name,
    String? password,
    String? id,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [email, name, password, id];
}
