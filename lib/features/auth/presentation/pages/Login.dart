import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:h_smart/features/auth/presentation/pages/Register.dart';
import '../../../../core/utils/appColor.dart' show AppColors;
import '../provider/auth_provider.dart';
import '../../../medical_record/presentation/pages/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
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
      _emailController.text.trim(),
      _passwordController.text,
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
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: msg ?? 'Welcome back!',
        status: SnackbarStatus.success,
      );

      final isComplete = result.response.payload?.isProfileComplete ?? true;
      if (isComplete) {
        context.pushReplacement('/home');
      } else {
        context.push('/complete-profile');
      }
    }
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
              'Log In to Your H-SMART Account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email / Phone',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildPasswordField(),
                  _buildRememberAndForgot(),
                  const Gap(16),
                  _buildLoginButton(),
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

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _passwordController,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) return 'Password can\'t be empty';
          return null;
        },
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
                value: _rememberMe,
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
              ),
              const Text('Remember Me'),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _onLogin,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.kprimaryColor500),
        child: const Center(
          child: Text("LOGIN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
        ),
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
