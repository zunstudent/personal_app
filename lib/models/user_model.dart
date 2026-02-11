class UserModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String? bio;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.bio,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      userId: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'],
      role: map['role'] ?? 'user',
    );
  }
}
