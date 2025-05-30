import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/customesnackbar.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:h_smart/features/auth/presentation/pages/Login.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../core/utils/appColor.dart' show AppColors;
import '../../presentation/provider/auth_provider.dart';

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

  bool _showPassword = false;
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
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _phoneNumber.completeNumber,
      _emailController.text.trim(),
      _passwordController.text,
    );
    SmartDialog.dismiss();

    final result = ref.watch(authProvider).registerResult;
    if (result.state == RegisterResultStates.isError) {
      _showSnackbar(result.response['message'] ?? 'Registration failed',
          isError: true);
    } else if (result.state == RegisterResultStates.isData) {
      _showSnackbar(result.response['message'] ?? 'Registered successfully');
      context.push('/verifyemail');
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
                  _buildTextField(
                      controller: _firstNameController, label: 'First Name'),
                  _buildTextField(
                      controller: _lastNameController, label: 'Last Name'),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildPhoneField(),
                  _buildPasswordField(),
                  _buildTermsCheckbox(),
                  const Gap(16),
                  _buildRegisterButton(),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUnfocus,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) {
            return '$label can\'t be empty';
          }
          if (label.toLowerCase() == 'email') {
            final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegEx.hasMatch(text)) {
              return 'Enter a valid email address';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntlPhoneField(
        initialCountryCode: 'NG',
        controller: _phoneController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (phone) => _phoneNumber = phone,
        validator: (value) => value == null || !value.isValidNumber()
            ? 'Enter a valid phone number'
            : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
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
        validator: (value) =>
            value == null || value.isEmpty ? 'Password can\'t be empty' : null,
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _agreedToTerms,
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'I agree to the Terms and Conditions and Privacy Policy',
        style: TextStyle(fontSize: 14),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: _onRegister,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.kprimaryColor500),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: const Center(
            child: Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        )),
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
