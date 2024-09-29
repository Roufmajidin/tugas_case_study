class LoginModel {
  final bool isAdmin;
  final String username;
  final String token;

  LoginModel({
    required this.isAdmin,
    required this.username,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      isAdmin: json['isAdmin'],
      username: json['username'],
      token: json['token'],
    );
  }
}
