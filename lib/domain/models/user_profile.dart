/// A network-safe user profile model used in the data/auth layer.
/// Separate from [SettingsModel] which carries UI-level state (isDarkMode, isLoading, etc).
///
/// When the backend returns a user object, it maps to this class first,
/// then [SettingsNotifier] copies the relevant fields into [SettingsModel].
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profileImagePath;
  final String? nickName;
  final String? phone;
  final String? address;
  final String? job;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImagePath,
    this.nickName,
    this.phone,
    this.address,
    this.job,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImagePath,
    String? nickName,
    String? phone,
    String? address,
    String? job,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      nickName: nickName ?? this.nickName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      job: job ?? this.job,
    );
  }

  /// Serializes to a JSON map suitable for REST API bodies.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profileImagePath': profileImagePath,
    'nickName': nickName,
    'phone': phone,
    'address': address,
    'job': job,
  };

  /// Deserializes from a JSON map (e.g., API response body).
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    profileImagePath: json['profileImagePath'] as String?,
    nickName: json['nickName'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    job: json['job'] as String?,
  );

  /// Creates a default guest profile for unauthenticated state.
  factory UserProfile.guest() => const UserProfile(
    id: 'guest',
    name: 'Aland Raed',
    email: 'aland.raed.othman@gmail.com',
  );
}
