import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  void changePassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "Korem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis."),
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  return null;
                                })),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Confirm Password",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  return null;
                                })),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: FilledButton(
                  onPressed: changePassword,
                  child: const Text("Update Password"),
                ),
              )
            ]));
  }
}
