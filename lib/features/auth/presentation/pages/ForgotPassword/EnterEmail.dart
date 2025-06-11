import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';

import '../../../../../core/utils/appColor.dart';
import '../../provider/auth_provider.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOneTimePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider);
    if (auth.loginResult.state == LoginResultStates.isLoading) return;

    SmartDialog.showLoading();
    await auth.sendotpChangePassword(
      email: _emailController.text.trim(),
    );
    SmartDialog.dismiss();

    final result = ref.watch(authProvider).sendTokenChangePasswordResult;
    final msg = result.response['message'];

    if (result.state == SendTokenChangePasswordResultStates.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: msg ?? 'Otp request failed',
        status: SnackbarStatus.fail,
      );
    } else if (result.state == SendTokenChangePasswordResultStates.isData) {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: msg ?? 'Otp Sent successfully',
        status: SnackbarStatus.success,
      );

      if (result.state == SendTokenChangePasswordResultStates.isData) {
        context.replace('/forgot-password/changePassword',
            extra: {"email": _emailController.text});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              'Forgot Password?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(24),
            const Text(
              'Please enter the email of your accout',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Gap(10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildLoginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) return '$label can\'t be empty';
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _sendOneTimePassword,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.kprimaryColor500),
        child: const Center(
          child: Text("Request Otp",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
