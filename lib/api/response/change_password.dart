class ChangePasswordRequest {
  final String email;
  final String password;
  final String newPassword;

  ChangePasswordRequest({
    required this.email,
    required this.password,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'newPassword': newPassword,
    };
  }
}
