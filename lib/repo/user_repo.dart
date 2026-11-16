import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/repo/env_variable.dart';

class UserRepo {
  Future<(User?, String)> userLogin(
      String loginCredentials, String password) async {
    try {
      var url = '$PRIM_URL/login';
      var uri = Uri.parse(url);

      Map<String, dynamic> loginData = {
        'email': loginCredentials,
        'password': password,
        'device_token': User.device_token ?? ''
      };

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return (User.fromJson(data), 'Login Successfully');
      } else {
        return (null, 'Invalid Login');
      }
    } catch (e) {
      //print("Error: $e");
      return (null, 'Please check your connection');
    }
  }

  Future<int> validateToken(String token) async {
    try {
      var url = '$PRIM_URL/validateToken';
      var uri = Uri.parse(url);

      Map<String, dynamic> tokenData = {
        'token': token,
      };

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tokenData),
      );

      return response.statusCode;
    } catch (e) {
      //print("Error: $e");
      return 0;
    }
  }

  Future<(bool, String)> userRegister({
    required String name,
    required String email,
    required String icno,
    required String telno,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$PRIM_MOBILE_URL/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          if (email.isNotEmpty) 'email': email,
          'icno': icno,
          'telno': telno,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (
          true,
          'Pendaftaran berjaya. Sila log masuk dengan akaun baharu anda.'
        );
      }
      return (false, _extractError(body));
    } catch (_) {
      return (false, 'Please check your connection');
    }
  }

  String _extractError(dynamic body) {
    if (body is Map) {
      final errors = body['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final messages = errors.values
            .expand((v) => v is List ? v : [v])
            .map((e) => e.toString())
            .toList();
        if (messages.isNotEmpty) return messages.join('\n');
      }
      if (body['message'] != null) return body['message'].toString();
      if (body['error'] != null) return body['error'].toString();
    }
    return 'Pendaftaran gagal. Sila cuba lagi.';
  }
}
