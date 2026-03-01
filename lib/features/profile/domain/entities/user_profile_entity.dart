class UserProfileEntity {
  final int id;
  final String? name;
  final String? phone;
  final String? email;

  const UserProfileEntity({
    required this.id,
    this.name,
    this.phone,
    this.email,
  });
}
