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
        context.push('/forgot-password/changePassword',
            extra: {"email": _emailController.text});
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Image.asset('images/logo1.png', width: 120),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),

              // Header Section
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.kprimaryColor500.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 48,
                    color: AppColors.kprimaryColor500,
                  ),
                ),
              ),

              const Gap(32),

              // Title and Description
              Center(
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),

              const Gap(12),

              Text(
                'No worries! Enter your email address and we\'ll send you a reset link to get back into your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7),
                  height: 1.5,
                ),
              ),

              const Gap(40),

              // Form Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      const Gap(8),
                      _buildEmailField(),
                      const Gap(24),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),

              const Gap(32),

              // Back to Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6),
                    ),
                    const Gap(8),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          color: AppColors.kprimaryColor500,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      decoration: InputDecoration(
        hintText: 'Enter your email address',
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 16,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          child: Icon(
            Icons.email_outlined,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[200]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.kprimaryColor500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return 'Email address is required';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _sendOneTimePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kprimaryColor500,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, size: 20),
            const Gap(12),
            Text(
              'Send Reset Link',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
