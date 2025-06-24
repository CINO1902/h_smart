import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../core/utils/appColor.dart' show AppColors;
import '../../presentation/provider/auth_provider.dart';
import '../widget/index.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _agreedToTerms = false;
  late PhoneNumber _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber =
        PhoneNumber(countryISOCode: 'NG', countryCode: '+234', number: '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = ref.read(authProvider);

    // if (auth.registerResult.state == RegisterResultStates.isLoading) return;

    if (!_agreedToTerms) {
      _showaction('You must accept the Terms and Conditions', isError: true);
      return;
    }

    SmartDialog.showLoading();
    await auth.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneNumber.completeNumber,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    SmartDialog.dismiss();

    final result = ref.watch(authProvider).registerResult;
    if (result.state == RegisterResultStates.isError) {
      _showSnackbar(result.response['message'] ?? 'Registration failed',
          isError: true);
    } else if (result.state == RegisterResultStates.isData) {
      _showSnackbar(result.response['message'] ?? 'Registered successfully');
      if (mounted) {
        context.push('/verify-email', extra: {
          "email": _emailController.text,
        });
      }
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    SnackBarService.showSnackBar(context,
        status: isError ? SnackbarStatus.fail : SnackbarStatus.success,
        title: isError ? 'Oh Snap!' : 'Great!',
        body: message);
  }

  void _showaction(String message, {bool isError = false}) {
    SnackBarService.notifyAction(context,
        message: message,
        status: isError ? SnackbarStatus.fail : SnackbarStatus.success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('images/logo1.png', width: 150),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                // Set the vertical margin here
                child: const Text("Create Your  H-SMART Account!",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
            const Gap(24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hint: 'Enter your first name',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.kprimaryColor500,
                      size: 20,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'First Name can\'t be empty';
                      return null;
                    },
                  ),
                  AuthTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hint: 'Enter your last name',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.kprimaryColor500,
                      size: 20,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Last Name can\'t be empty';
                      return null;
                    },
                  ),
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
                      if (text.isEmpty) {
                        return 'Email can\'t be empty';
                      }
                      final emailRegEx =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegEx.hasMatch(text)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  AuthPhoneField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    onChanged: (phone) => _phoneNumber = phone,
                    validator: (value) =>
                        value == null || !value.isValidNumber()
                            ? 'Enter a valid phone number'
                            : null,
                  ),
                  AuthPasswordField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    textInputAction: TextInputAction.done,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Password can\'t be empty'
                        : null,
                  ),
                  AuthCheckbox(
                    value: _agreedToTerms,
                    onChanged: (val) =>
                        setState(() => _agreedToTerms = val ?? false),
                    label:
                        'I agree to the Terms and Conditions and Privacy Policy',
                  ),
                  const Gap(16),
                  AuthButton(
                    text: 'Sign Up',
                    onPressed: _onRegister,
                    isLoading: ref.watch(authProvider).registerResult.state ==
                        RegisterResultStates.isLoading,
                  ),
                  const Gap(16),
                  _buildLoginLink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () => context.push('/login'),
          child: const Text(
            'Login',
            style: TextStyle(
                color: AppColors.kprimaryColor500, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
