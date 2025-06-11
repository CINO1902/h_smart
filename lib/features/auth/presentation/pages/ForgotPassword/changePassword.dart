import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constant/snackbar.dart';
import '../../../../../core/utils/appColor.dart';
import '../../../domain/usecases/authStates.dart';
import '../../provider/auth_provider.dart';

class Changepassword extends ConsumerStatefulWidget {
  String email;
  Changepassword({Key? key, required this.email}) : super(key: key);

  @override
  ConsumerState<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends ConsumerState<Changepassword> {
  Timer? _countdownTimer;
  final _formKey = GlobalKey<FormState>();
  final _accesstokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  int _remainingSeconds = 60; // start at 60 seconds

  bool showPassword = false;
  bool showPassword1 = false;
  @override
  void dispose() {
    _accesstokenController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  Future<void> _changepassword() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider);
    if (auth.loginResult.state == LoginResultStates.isLoading) return;

    SmartDialog.showLoading();
    await auth.changepassword(
        changePasswordToken: _accesstokenController.text.trim(),
        password: _passwordController.text.trim());
    SmartDialog.dismiss();

    final result = ref.watch(authProvider).changePasswordResult;
    final msg = result.response['message'];

    if (result.state == ChangePasswordResultStates.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: msg ?? 'Otp request failed',
        status: SnackbarStatus.fail,
      );
    } else if (result.state == ChangePasswordResultStates.isData) {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: msg ?? 'Otp Sent successfully',
        status: SnackbarStatus.success,
      );

      context.go('/forgot-password/passwordchangecomplete');
    }
  }

  void _startCountdown() {
    // Reset to 60 and (re)start the timer
    _remainingSeconds = 60;

    // Cancel any existing timer
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _resendCode() async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset('images/logo1.png', width: 150),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Reset Password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(24),
            const Gap(10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _accesstokenController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffix: IntrinsicWidth(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _buildSuffixWidget(),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          )),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Access code cannot be empty';
                        return null;
                      },
                    ),
                  ),
                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'Enter Password',
                    showPassword: showPassword,
                    onToggleShow: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Password can\'t be empty';
                      if (text.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  _buildPasswordField(
                    controller: _cpasswordController,
                    label: 'Confirm Password',
                    showPassword: showPassword1,
                    onToggleShow: () {
                      setState(() {
                        showPassword1 = !showPassword1;
                      });
                    },
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Confirm Password can\'t be empty';
                      }
                      if (text != _passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const Gap(16),
                  _buildLoginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool showPassword,
    required VoidCallback onToggleShow,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
          controller: controller,
          obscureText: !showPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggleShow,
            ),
          ),
          validator: validator),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _changepassword,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.kprimaryColor500),
        child: const Center(
          child: Text("Change Password",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildSuffixWidget() {
    if (_remainingSeconds > 0) {
      // Show countdown: e.g. "00:59", "00:58", ...
      final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

      return Text(
        // Format as MM:SS
        "$minutes:$seconds",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _resendCode();
          _startCountdown();
        },
        child: const Text(
          "Resend",
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }
}
