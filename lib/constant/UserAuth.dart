import 'package:flutter/material.dart';
import 'package:h_smart/features/auth/presentation/pages/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserAuth {
  static Future<String> getAuthToken(context) async {
    final pref = await SharedPreferences.getInstance();
    String? jwt = pref.getString('jwt_token');
    if (jwt == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
    return jwt!;
  }

  static Future<String> getAuthTokenAsBearerKey(context) async {
    String? jwt =
        (await SharedPreferences.getInstance()).getString('jwt_token');
    if (jwt == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
    return "Bearer " + jwt!;
  }

  static Future<void> setAuthToken(token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('jwt_token', token);
  }
}
