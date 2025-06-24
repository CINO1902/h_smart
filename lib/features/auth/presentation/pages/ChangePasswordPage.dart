import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'dart:async';

import '../../../../constant/snackbar.dart';
import '../../domain/usecases/authStates.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  final String email;
  const ChangePasswordPage({super.key, required this.email});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _accessTokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  int _countdownSeconds = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _accessTokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _countdownSeconds = 60;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() => _countdownSeconds--);
      } else {
        timer.cancel();
        // Force rebuild so suffixIcon falls back to the Send button
        setState(() {});
      }
    });
  }

  Future<void> _sendAccessToken() async {
    final auth = ref.read(authProvider);
    if (auth.sendTokenChangePasswordResult.state ==
        SendTokenChangePasswordResultStates.isLoading) {
      return;
    }

    await auth.sendotpChangePassword(email: widget.email);

    // Read the *new* state/result
    final result = auth.sendTokenChangePasswordResult;

    if (result.state == SendTokenChangePasswordResultStates.isError) {
      if (mounted) {
        setState(() {}); // rebuild to show Send again
        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          body: 'Failed to send access token: ${result.response['message']}',
          status: SnackbarStatus.fail,
        );
      }
      return;
    }

    if (result.state == SendTokenChangePasswordResultStates.isData) {
      if (mounted) {
        _startCountdown();
        SnackBarService.notifyAction(
          context,
          message: 'Access token sent to your email',
          status: SnackbarStatus.success,
        );
      }
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(authProvider).changePasswordResult.state;
    if (state == ChangePasswordResultStates.isLoading) return;

    // TODO: Implement password change API call
    await ref.read(authProvider).changepassword(
        changePasswordToken: _accessTokenController.text,
        password: _newPasswordController.text);
    final changePasswordResult = ref.read(authProvider).changePasswordResult;
    final state2 = ref.read(authProvider).changePasswordResult.state;
    if (state2 == ChangePasswordResultStates.isError) {
      if (mounted) {
        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          body:
              'Failed to update password ${changePasswordResult.response['message']}',
          status: SnackbarStatus.fail,
        );
      }
    }
    if (state2 == ChangePasswordResultStates.isData) {
      if (mounted) {
        SnackBarService.notifyAction(
          context,
          message: 'Password updated successfully',
          status: SnackbarStatus.success,
        );
        context.replace('/forgot-password/passwordchangecomplete');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider).sendTokenChangePasswordResult.state;
    final statechangepassword =
        ref.watch(authProvider).changePasswordResult.state;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Change Password',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.kprimaryColor500.withOpacity(0.1)
                        : AppColors.kprimaryColor500.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.kprimaryColor500.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.kprimaryColor500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.security_outlined,
                          color: AppColors.kprimaryColor500,
                          size: 24,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Secure Your Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'Enter the access token sent to your email to change your password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(32),

                // Access token field
                Text(
                  'Access Token',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                const Gap(8),
                TextFormField(
                  controller: _accessTokenController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your access token',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.kprimaryColor500,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      child: _countdownSeconds > 0
                          // 1) countdown display
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[700]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_countdownSeconds}s',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                            )
                          // 2) still loading? show spinner
                          : state ==
                                  SendTokenChangePasswordResultStates.isLoading
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[700]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.kprimaryColor500,
                                      ),
                                    ),
                                  ),
                                )
                              // 3) otherwise allow send again
                              : ElevatedButton(
                                  onPressed: _sendAccessToken,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.kprimaryColor500,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Access token is required';
                    }
                    return null;
                  },
                ),
                const Gap(24),

                // New password field
                Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                const Gap(8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your new password',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.kprimaryColor500,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'New password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                        .hasMatch(value)) {
                      return 'Password must contain uppercase, lowercase, and number';
                    }
                    return null;
                  },
                ),
                const Gap(8),

                // Password strength indicator
                _buildPasswordStrengthIndicator(_newPasswordController.text),
                const Gap(24),

                // Confirm password field
                Text(
                  'Confirm New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                const Gap(8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm your new password',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.kprimaryColor500,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const Gap(32),

                // Password requirements
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[800]?.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey[700]!.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleSmall?.color,
                        ),
                      ),
                      const Gap(8),
                      _buildRequirement('At least 8 characters long',
                          _newPasswordController.text.length >= 8),
                      _buildRequirement(
                          'Contains uppercase letter',
                          RegExp(r'[A-Z]')
                              .hasMatch(_newPasswordController.text)),
                      _buildRequirement(
                          'Contains lowercase letter',
                          RegExp(r'[a-z]')
                              .hasMatch(_newPasswordController.text)),
                      _buildRequirement('Contains a number',
                          RegExp(r'\d').hasMatch(_newPasswordController.text)),
                    ],
                  ),
                ),
                const Gap(32),

                // Update button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: statechangepassword ==
                            ChangePasswordResultStates.isLoading
                        ? null
                        : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kprimaryColor500,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: statechangepassword ==
                            ChangePasswordResultStates.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_reset_rounded, size: 20),
                              const Gap(12),
                              Text(
                                'Update Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    if (password.isEmpty) return const SizedBox.shrink();

    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'\d').hasMatch(password)) strength++;

    Color color;
    String text;
    switch (strength) {
      case 0:
      case 1:
        color = Colors.red;
        text = 'Weak';
        break;
      case 2:
        color = Colors.orange;
        text = 'Fair';
        break;
      case 3:
        color = Colors.yellow.shade700;
        text = 'Good';
        break;
      case 4:
        color = Colors.green;
        text = 'Strong';
        break;
      default:
        color = Colors.grey;
        text = '';
    }

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: strength / 4,
            backgroundColor: ref.read(themeModeCheckerProvider)(context)
                ? Colors.grey[700]
                : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet
                ? Colors.green
                : Theme.of(context).iconTheme.color?.withOpacity(0.5),
          ),
          const Gap(8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet
                  ? Colors.green
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
