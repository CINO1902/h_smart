import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import '../../../../core/utils/appColor.dart' show AppColors;
import '../../../Hospital/presentation/provider/getHospitalProvider.dart';
import '../provider/auth_provider.dart';
import '../../../settings/presentation/providers/security_provider.dart';
import '../widget/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider);
    if (auth.loginResult.state == LoginResultStates.isLoading) return;

    SmartDialog.showLoading();

    await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    SmartDialog.dismiss();

    final result = ref.watch(authProvider).loginResult;
    final msg = result.response.message;

    if (result.state == LoginResultStates.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: msg ?? 'Login failed',
        status: SnackbarStatus.fail,
      );
    } else if (result.state == LoginResultStates.isData) {
      if (_rememberMe) {
        print('should save this ${_emailController.text}');
        ref.read(authProvider).saveEmailLogin(_emailController.text);
      } else {
        ref.read(authProvider).unSaveEmailLogin();
      }

      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: msg ?? 'Welcome back!',
        status: SnackbarStatus.success,
      );

      // Save credentials for biometric login if user has biometric enabled
      final securityNotifier = ref.read(securityProvider.notifier);

      await securityNotifier.saveLoginCredentials(
        _emailController.text.trim(),
        _passwordController.text,
      );

      final isComplete = result.response.payload?.isProfileComplete ?? true;
      final emailVerified = result.response.payload?.status ?? '';
      if (emailVerified == 'active') {
        if (isComplete) {
          context.go('/home');
        } else {
          context.push('/complete-profile');
        }
      } else {
        context.push('/verify-email', extra: {
          "email": _emailController.text,
        });
      }
    }
  }

  Future<void> _onBiometricLogin() async {
    final securityNotifier = ref.read(securityProvider.notifier);
    final securityState = ref.read(securityProvider);

    if (!securityNotifier.hasBiometricEnabled) {
      SnackBarService.showSnackBar(
        context,
        title: 'Biometric Not Enabled',
        body:
            'Please enable ${securityNotifier.biometricType} in Settings > Security first',
        status: SnackbarStatus.fail,
      );
      return;
    }

    if (securityState.savedEmail.isEmpty ||
        securityState.savedPassword.isEmpty) {
      SnackBarService.showSnackBar(
        context,
        title: 'No Saved Credentials',
        body:
            'Please login with your email and password first to save credentials for ${securityNotifier.biometricType}',
        status: SnackbarStatus.fail,
      );
      return;
    }

    // Authenticate with biometrics
    final authenticated = await securityNotifier.authenticateWithBiometrics();

    if (!authenticated) {
      SnackBarService.showSnackBar(
        context,
        title: 'Authentication Failed',
        body:
            '${securityNotifier.biometricType} authentication was cancelled or failed',
        status: SnackbarStatus.fail,
      );
      return;
    }

    // Populate fields with saved credentials
    setState(() {
      _emailController.text = securityState.savedEmail;
      _passwordController.text = securityState.savedPassword;
    });

    // Proceed with login
    await _onLogin();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authProvider);
      await _loadRememberMe();
      updateEmailField();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     ref.read(authProvider);
  //     await _loadRememberMe();
  //     updateEmailField();
  //   });
  // }

  Future<void> _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  Future<void> _setRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
    setState(() {
      _rememberMe = value;
    });
  }

  updateEmailField() async {
    await Future.delayed(const Duration(microseconds: 500));
    final savedEmail = ref.read(authProvider).emailLogin;
    if (savedEmail.isNotEmpty) {
      print('object is $savedEmail');
      _emailController.text = savedEmail;
      // _rememberMe = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(securityProvider);
    final securityNotifier = ref.read(securityProvider.notifier);
    final hasBiometricEnabled = securityNotifier.hasBiometricEnabled;
    final biometricType = securityNotifier.biometricType;

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
              'Log In to Your H-SMART Account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(24),

            // Biometric login button
            if (hasBiometricEnabled && securityState.savedEmail.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: _onBiometricLogin,
                  icon: Icon(
                    biometricType == 'Face ID'
                        ? Icons.face_outlined
                        : biometricType == 'Touch ID'
                            ? Icons.fingerprint_outlined
                            : Icons.key_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Sign in with $biometricType',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kprimaryColor500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

            // Divider
            if (hasBiometricEnabled && securityState.savedEmail.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const Gap(24),
            ],

            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.kprimaryColor500,
                      size: 20,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Email can\'t be empty';
                      return null;
                    },
                  ),
                  AuthPasswordField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Password can\'t be empty';
                      return null;
                    },
                  ),
                  _buildRememberAndForgot(),
                  const Gap(16),
                  AuthButton(
                    text: 'LOGIN',
                    onPressed: _onLogin,
                    isLoading: ref.watch(authProvider).loginResult.state ==
                        LoginResultStates.isLoading,
                  ),
                  const Gap(16),
                  _buildRegisterLink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberAndForgot() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: AppColors.kprimaryColor500,
                value: _rememberMe,
                onChanged: (val) => _setRememberMe(val ?? false),
              ),
              const Text('Remember Me'),
            ],
          ),
          TextButton(
            onPressed: () {
              context.push('/forgot-password');
            },
            child: const Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        const Gap(4),
        TextButton(
          onPressed: () => context.push('/register'),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
