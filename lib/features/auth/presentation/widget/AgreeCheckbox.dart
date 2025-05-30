/// lib/features/auth/presentation/widgets/agree_checkbox.dart
import 'package:flutter/material.dart';

class AgreeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const AgreeCheckbox({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const Expanded(
          child: Text(
            'I read and agreed to the Terms and Conditions and Privacy Policy.',
          ),
        ),
      ],
    );
  }
}
