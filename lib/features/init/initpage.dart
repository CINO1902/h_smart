import 'package:flutter/material.dart';
import 'package:h_smart/features/auth/presentation/pages/Login.dart';
import 'package:h_smart/features/auth/presentation/pages/WelcomePage.dart';
import 'package:h_smart/features/medical_record/presentation/pages/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeciderScreen extends StatefulWidget {
  const DeciderScreen({super.key});

  @override
  _DeciderScreenState createState() => _DeciderScreenState();
}

class _DeciderScreenState extends State<DeciderScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');

    setState(() {
      // hasSeenOnboarding = seen;
      token = prefs.getString('jwt_token');
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return token != null ? const indexpage() : const WelcomePage();
  }
}
