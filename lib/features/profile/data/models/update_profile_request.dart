class UpdateProfileRequest {
  final String method;
  final String name;
  final String phone;
  final String email;

  const UpdateProfileRequest({
    this.method = 'put',
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {'_method': method, 'name': name, 'phone': phone, 'email': email};
  }
}
