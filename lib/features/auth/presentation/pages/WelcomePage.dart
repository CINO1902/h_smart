import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import 'Login.dart';
import 'Register.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'images/logo1.png',
          width: 200,
          height: 150,
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("WELCOME TO H-SMART!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  )),
              Gap(10),
              const Text(
                  "Create an account or log in to unlock the full potential \nof H-Smart.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                  )),
              Gap(30),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: InkButton(
                    title: 'Create free H-Smart account',
                  )),
              Gap(20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  // Button action
                },
                child: Container(
                  width: 350,
                  height: 54,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1)),
                  child: Center(
                      child: Text(
                    'Sign In',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
                ),
              ),
            ]),
      ),
    );
  }
}
