import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool curentpassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Change Password',
            style: TextStyle(fontSize: 19),
          )),
      body: Stack(children: [
        Form(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text('Current Password'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                    obscureText: true,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            curentpassword = !curentpassword;
                          });
                        },
                        child: curentpassword
                            ? Icon(
                                Icons.visibility,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                      ),
                      contentPadding: const EdgeInsets.only(top: 5, left: 10),
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xffEAECF0))),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Password can't be empty";
                      }
                    }),
              ),
              const Gap(20),
              const Text('New Password'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                    obscureText: true,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            curentpassword = !curentpassword;
                          });
                        },
                        child: curentpassword
                            ? Icon(
                                Icons.visibility,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                      ),
                      contentPadding: const EdgeInsets.only(top: 5, left: 10),
                      hintText: "Enter new password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xffEAECF0))),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Password can't be empty";
                      }
                    }),
              ),
              const Gap(20),
              const Text('Confirm New Password'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                    obscureText: true,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            curentpassword = !curentpassword;
                          });
                        },
                        child: curentpassword
                            ? Icon(
                                Icons.visibility,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                      ),
                      contentPadding: const EdgeInsets.only(top: 5, left: 10),
                      hintText: "Confirm New Passwordd",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xffEAECF0))),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Password can't be empty";
                      }
                    }),
              ),
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(child: InkButton(title: 'Submit'))),
        )
      ]),
    );
  }
}
