import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:gap/gap.dart';

import '../../../../../constant/Inkbutton.dart';
import '../../../../../constant/snackbar.dart';
import '../../../../../core/theme/theme_mode_provider.dart';
import '../../../../../core/utils/appColor.dart';
import '../../../domain/usecases/authStates.dart';
import '../../provider/auth_provider.dart';

class VerifyPasswordOtp extends ConsumerStatefulWidget {
  String email;
  VerifyPasswordOtp({Key? key, required this.email}) : super(key: key);

  @override
  ConsumerState<VerifyPasswordOtp> createState() => _VerifyPasswordOtpState();
}

class _VerifyPasswordOtpState extends ConsumerState<VerifyPasswordOtp> {
  final TextEditingController _otpController = TextEditingController();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>.broadcast();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Timer _timer;
  int _remainingSeconds = 60;
  String _currentOtp = "";

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    _errorController.close();
    super.dispose();
  }

  void _startCountdown() {
    _remainingSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> _resendCode() async {
    setState(() {
      _remainingSeconds = 60;
    });
    _startCountdown();
    SmartDialog.showLoading();
    await ref.read(authProvider).callActivation(email: widget.email);
    SmartDialog.dismiss();
    final verifyState = ref.read(authProvider).emailVerificationResult.state;
    final responseMsg = ref
            .read(authProvider)
            .emailVerificationResult
            .response['message'] as String? ??
        'Unknown error';
    if (verifyState == EmailVerificationResultState.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: responseMsg,
        status: SnackbarStatus.fail,
      );
    } else {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: responseMsg,
        status: SnackbarStatus.success,
      );

      // Navigate to profile completion and remove this page from history
    }
  }

  Future<void> _verifyAndContinue() async {
    if (_currentOtp.length != 4) {
      SnackBarService.notifyAction(
        context,
        message: 'OTP must be 4 digits.',
      );
      return;
    }

    final verifyState = ref.read(authProvider).verifyEmailResult.state;
    if (verifyState == VerifyEmailResultStates.isLoading) {
      return;
    }

    SmartDialog.showLoading();
    await ref.read(authProvider).verifyOtp(_currentOtp);
    SmartDialog.dismiss();

    final resultState = ref.read(authProvider).verifyEmailResult.state;
    final responseMsg = ref
            .read(authProvider)
            .verifyEmailResult
            .response['message'] as String? ??
        'Unknown error';

    if (resultState == VerifyEmailResultStates.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: responseMsg,
        status: SnackbarStatus.fail,
      );
    } else {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: responseMsg,
        status: SnackbarStatus.success,
      );

      // Navigate to profile completion and remove this page from history
    }
    if (resultState == VerifyEmailResultStates.isData) {
      context.replace('/forgot-password/changePassword');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(themeModeCheckerProvider)(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset('images/logo1.png', width: 150),
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.chevron_left,
              size: 28,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              const Text(
                'Confirm Your Email',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              const Text(
                'We’ve sent an OTP to your email address.\nPlease check your inbox.',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(30),
              const Text(
                'Enter the 4 digit code',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(5),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  animationType: AnimationType.fade,
                  blinkWhenObscuring: true,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: _otpController,
                  errorAnimationController: _errorController,
                  keyboardType: TextInputType.text,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 54,
                    fieldWidth: 75,
                    activeColor:
                        isDarkMode ? Colors.grey[700] : const Color(0xffEBF1FF),
                    inactiveColor:
                        isDarkMode ? Colors.grey[700] : const Color(0xffEBF1FF),
                    selectedColor:
                        isDarkMode ? Colors.grey[700] : const Color(0xffEBF1FF),
                    inactiveFillColor:
                        isDarkMode ? Colors.grey[700] : const Color(0xffEBF1FF),
                    selectedFillColor:
                        isDarkMode ? Colors.grey[700] : const Color(0xffEBF1FF),
                    activeFillColor:
                        isDarkMode ? Colors.grey[700] : const Color(0xffEBF1FF),
                  ),
                  cursorColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      _currentOtp = value;
                    });
                  },
                  onCompleted: (value) {
                    _currentOtp = value;
                  },
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return 'Please enter 4 digits';
                    }
                    return null;
                  },
                  beforeTextPaste: (text) => true,
                ),
              ),
              const Gap(40),
              const Center(
                child: Text(
                  'Didn\'t receive the email?',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const Gap(10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Resend Code?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.kprimaryColor500,
                      ),
                    ),
                    const Gap(10),
                    _remainingSeconds == 0
                        ? InkWell(
                            onTap: _resendCode,
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.kprimaryColor500,
                              ),
                            ),
                          )
                        : Text(
                            '(${_formatTime(_remainingSeconds)})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kprimaryColor500,
                            ),
                          ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: InkWell(
                  onTap: _verifyAndContinue,
                  child: InkButton(
                    title: 'Verify and continue',
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
