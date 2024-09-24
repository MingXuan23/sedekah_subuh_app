import 'package:prim_derma_app/repo/env_variable.dart';
import 'package:prim_derma_app/repo/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String loginCredentials = "";
  String? password = "";
  String name;
  String? token;
  String? referral_code;

  static String? device_token;

  User(
      {required this.loginCredentials,
      this.password,
      this.token,
      this.referral_code,
      required this.name});

  User.Authenticate(
      {required this.name, required this.token, this.referral_code});
  factory User.fromJson(Map<String, dynamic> json) {
    return User.Authenticate(
        name: (json['name'] ?? '').toString(),
        token: (json['token'] ?? '').toString(),
        referral_code: (json['referral_code'] ?? '').toString());
  }

  toJson() {
    return {'loginCredentials': loginCredentials, 'password': password};
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
  }

  static Future<String?> retrieveToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    return token;
  }

   static Future<void> saveEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user_email', email);
  }

  static Future<String?> retrieveEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString('user_email');
    return email;
  }

  static Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }

  static Future<bool> validateLogin() async {
    if (!await validateEnvironment()) {
      return false;
    }
    var token = await User.retrieveToken();
    if (token == null) {
      return false;
    }
    var response = await UserRepo().validateToken(token);
    return (response == 200);
  }
}
