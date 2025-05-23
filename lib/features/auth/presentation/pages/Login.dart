import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';

import 'package:h_smart/constant/customesnackbar.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';

import '../../../medical_record/presentation/pages/index.dart';
import '../provider/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isRememberMeChecked = false;
  bool passvisible = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
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
                Gap(10),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    // Set the vertical margin here
                    child: const Text("Log In to Your H-Smart Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16))),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Email'),
                              const Gap(5),
                              TextFormField(
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                  hintText: "Email / Phone",
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
                              horizontal: 8, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Password'),
                              Gap(5),
                              TextFormField(
                                  controller: passwordcontroller,
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
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Password can't be empty";
                                    }
                                  }),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isRememberMeChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isRememberMeChecked = value!;
                                    });
                                  },
                                ),
                                const Text("Remember Me",
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.left),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 2.0),
                                child: GestureDetector(
                                  onTap: () => {},
                                  child: const Text("Forgot Password?",
                                      style: TextStyle(color: Colors.blue),
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.left),
                                )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (ref.read(authProvider).loginResult.state ==
                              LoginResultStates.isLoading) {
                            return;
                          }
                          print('object');
                          SmartDialog.showLoading();
                          await ref.read(authProvider).login(
                              emailcontroller.text, passwordcontroller.text);
                          if (ref.watch(authProvider).loginResult.state ==
                              LoginResultStates.isError) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: CustomeSnackbar(
                                topic: 'Oh Snap!',
                                msg: ref
                                        .watch(authProvider)
                                        .loginResult
                                        .response
                                        .message ??
                                    '',
                                color1: Color.fromARGB(255, 171, 51, 42),
                                color2: Color.fromARGB(255, 127, 39, 33),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ));
                          } else if (ref
                                  .watch(authProvider)
                                  .loginResult
                                  .state ==
                              LoginResultStates.isData) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: CustomeSnackbar(
                                topic: 'Great!',
                                msg: ref
                                        .watch(authProvider)
                                        .loginResult
                                        .response
                                        .message ??
                                    '',
                                color1: Color.fromARGB(255, 25, 107, 52),
                                color2: Color.fromARGB(255, 19, 95, 40),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ));
                            if (ref
                                    .watch(authProvider)
                                    .loginResult
                                    .response
                                    .payload
                                    ?.isProfileCompleted ??
                                true) {
                              Navigator.pushAndRemoveUntil<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const indexpage()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Navigator.pushNamed(
                                  context, '/CompleteProfilePage');
                            }
                          }

                          SmartDialog.dismiss();
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
                            child: Text("LOGIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'nt have an account ?'),
                          Gap(10),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Click here',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
