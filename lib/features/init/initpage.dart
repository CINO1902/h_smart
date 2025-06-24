import 'package:flutter/material.dart';

import 'package:h_smart/features/auth/presentation/pages/WelcomePage.dart';
import 'package:h_smart/features/medical_record/presentation/pages/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h_smart/features/init/onboarding.dart'; // Import your onboarding screen

class DeciderScreen extends StatefulWidget {
  const DeciderScreen({super.key});

  @override
  _DeciderScreenState createState() => _DeciderScreenState();
}

class _DeciderScreenState extends State<DeciderScreen> {
  String? token;
  bool? hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (hasSeenOnboarding == null) {
      // Still loading
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!hasSeenOnboarding!) {
      return const OnboardingScreen();
    }
    return token != null ? const indexpage() : const WelcomePage();
  }
}
