import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import '../../../../core/utils/appColor.dart';

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
              const Gap(10),
              const Text(
                  "Create an account or log in to unlock the full potential \nof H-Smart.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                  )),
              const Gap(30),
              InkWell(
                  onTap: () {
                    context.push('/register');
                  },
                  child: InkButton(
                    title: 'Create free H-Smart account',
                  )),
              const Gap(20),
              InkWell(
                onTap: () {
                  context.push('/login');

                  // Button action
                },
                child: Container(
                  width: 350,
                  height: 54,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.kprimaryColor500, width: 1)),
                  child: const Center(
                      child: Text(
                    'Sign In',
                    style: TextStyle(color: AppColors.kprimaryColor500),
                  )),
                ),
              ),
            ]),
      ),
    );
  }
}
