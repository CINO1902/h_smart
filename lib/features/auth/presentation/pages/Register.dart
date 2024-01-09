import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

import 'package:provider/provider.dart';

import '../../../../constant/customesnackbar.dart';
import 'CompleteProfile.dart';
import 'Login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  bool confirmpassvisible = true;
  bool passvisible = true;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void register(authprovider value) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (value.loading == true) {
      return;
    } else if (isPrivacyPolicyChecked == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'You have to accept the terms and condition',
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      return;
    }
    SmartDialog.showLoading();
    await context
        .read<authprovider>()
        .register(emailController.text, passwordController.text);
    if (value.error == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: value.message,
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Great!',
          msg: value.message,
          color1: Color.fromARGB(255, 25, 107, 52),
          color2: Color.fromARGB(255, 19, 95, 40),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      Navigator.pushNamed(context, '/verifyemail');
    }
    SmartDialog.dismiss();
  }

  bool isPrivacyPolicyChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          'images/logo1.png',
          width: 200,
          height: 150,
        ),
      ),
      body: Container(
          alignment: const Alignment(0, -0.2),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  // Set the vertical margin here
                  child: const Text("Create Your  H-SMART Account!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18))),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email'),
                            Gap(5),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your email address",
                                hintStyle:
                                    const TextStyle(color: Color(0xffBEBEBE)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: Color(0xffEAECF0))),
                              ),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Email can't be empty";
                                }
                              },
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password'),
                            Gap(5),
                            TextFormField(
                              controller: passwordController,
                              obscureText: passvisible,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      passvisible = !passvisible;
                                    });
                                  },
                                  child: passvisible
                                      ? Icon(
                                          Icons.visibility,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                ),
                                hintText: "Enter your password",
                                hintStyle:
                                    const TextStyle(color: Color(0xffBEBEBE)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: Color(0xffEAECF0))),
                              ),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Password can't be empty";
                                }
                              },
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Confirm Password'),
                            Gap(5),
                            TextFormField(
                              obscureText: confirmpassvisible,
                              controller: cpasswordController,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      confirmpassvisible = !confirmpassvisible;
                                    });
                                  },
                                  child: confirmpassvisible
                                      ? Icon(
                                          Icons.visibility,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                ),
                                hintText: "Confirm your password",
                                hintStyle:
                                    const TextStyle(color: Color(0xffBEBEBE)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: Color(0xffEAECF0))),
                              ),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Password can't be empty";
                                } else if (cpasswordController.text !=
                                    passwordController.text) {
                                  return "Password does not match";
                                }
                              },
                            ),
                          ],
                        )),
                    // Padding(
                    //     padding:
                    //     const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    //     child: InputDatePickerFormField(
                    //       fieldLabelText: "Date Of Birth",
                    //       firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                    //       lastDate: DateTime.now(),)),
                    Gap(7),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Checkbox(
                            value: isPrivacyPolicyChecked,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                isPrivacyPolicyChecked = value!;
                              });
                            },
                          ),
                          const Flexible(
                              child: Text(
                                  "I read and agreed to the Terms and Conditions and Privacy Policy.",
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left))
                        ],
                      ),
                    ),
                    Consumer<authprovider>(builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          register(value);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(context).primaryColor),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: const Center(
                              child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      );
                    }),

                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          const Text("Already have an account?",
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left),
                          Flexible(
                            child: GestureDetector(
                              child: Text(" Login",
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ))
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
