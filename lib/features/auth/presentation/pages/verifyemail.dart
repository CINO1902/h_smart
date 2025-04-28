import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../constant/Inkbutton.dart';
import '../../../../constant/customesnackbar.dart';

class verifyemail extends ConsumerStatefulWidget {
  const verifyemail({super.key});

  @override
  ConsumerState<verifyemail> createState() => _verifyemailState();
}

class _verifyemailState extends ConsumerState<verifyemail> {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  int count = 59;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 60;
    countdown();
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  Timer t = Timer(const Duration(), () {});

  void countdown() {
    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset('images/chevron-left.png')),
              ),
              const Gap(20),
              const Text(
                'Verify Your Email',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              const Text(
                'We’ve sent an OTP to your email address. Please check your inbox',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(30),
              const Text(
                'Enter the 4 digit code',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(5),
              Form(
                key: formKey,
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 3) {
                      return "Must be four numbers";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    selectedColor: const Color(0xffEBF1FF),
                    selectedFillColor: const Color(0xffEBF1FF),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 54,
                    activeColor: const Color(0xffEBF1FF),
                    fieldWidth: 75,
                    inactiveColor: const Color(0xffEBF1FF),
                    inactiveFillColor: const Color(0xffEBF1FF),
                    activeFillColor: const Color(0xffEBF1FF),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,

                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              const Gap(40),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Didn\'t receive the email?',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend Code?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor),
                  ),
                  const Gap(10),
                  count == 0
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              count = 60;
                              countdown();
                            });
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : Text(
                          '(0:$count)',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor),
                        ),
                ],
              ),
              Align(
                  heightFactor: 6,
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      if (currentText.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: CustomeSnackbar(
                            topic: 'Oh Snap!',
                            msg: 'Enter The Complete Otp',
                            color1: Color.fromARGB(255, 171, 51, 42),
                            color2: Color.fromARGB(255, 127, 39, 33),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ));
                        return;
                      }
                      if (ref.read(authProvider).verifyEmailResult.state ==
                          VerifyEmailResultStates.isLoading) {
                        return;
                      }
                      SmartDialog.showLoading();
                      await ref.read(authProvider).verifyOtp(currentText);
                      if (ref.read(authProvider).verifyEmailResult.state ==
                          VerifyEmailResultStates.isError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: CustomeSnackbar(
                            topic: 'Oh Snap!',
                            msg: ref
                                .read(authProvider)
                                .verifyEmailResult
                                .response['message'],
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
                            msg: ref
                                .read(authProvider)
                                .verifyEmailResult
                                .response['message'],
                            color1: Color.fromARGB(255, 25, 107, 52),
                            color2: Color.fromARGB(255, 19, 95, 40),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ));
                        Navigator.pushNamed(context, '/CompleteProfilePage');
                      }
                      SmartDialog.dismiss();
                    },
                    child: InkButton(
                      title: 'Verify and continue',
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
