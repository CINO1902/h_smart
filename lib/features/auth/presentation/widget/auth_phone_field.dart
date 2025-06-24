import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:h_smart/core/utils/appColor.dart';

class AuthPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(PhoneNumber?)? validator;
  final ValueChanged<PhoneNumber>? onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String initialCountryCode;

  const AuthPhoneField({
    Key? key,
    required this.controller,
    this.label = 'Phone Number',
    this.hint,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.initialCountryCode = 'NG',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntlPhoneField(
        controller: controller,
        initialCountryCode: initialCountryCode,
        onChanged: onChanged,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        validator: validator,
      
        decoration: InputDecoration(
          labelText: 'Phone Number',
          hintText: 'Enter phone number',
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.phone_outlined,
              color: AppColors.kprimaryColor500,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
