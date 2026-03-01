class UserEntity {
  final int id;
  final String name;
  final String email;
  final String accessToken;
  final String tokenType;
  final String userType;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.tokenType,
    required this.userType,
  });
}
