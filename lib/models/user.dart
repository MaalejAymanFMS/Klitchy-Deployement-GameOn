class Login {
  String? message;
  String? homePage;
  String? fullName;
  Login({
    this.message,
    this.homePage,
    this.fullName,
});
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      message: json["message"],
      homePage: json["home_page"],
      fullName: json["full_name"]
    );
  }
}

class User {
  String? email;
  String? password;
  String? token;
  String? role;
  User({
    this.email,
    this.password,
    this.token,
    this.role,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json["email"],
        password: json["password"],
        token: json["token"],
        role: json["role"],
    );
  }
}