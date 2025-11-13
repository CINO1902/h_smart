import 'package:flutter/material.dart';
import 'package:h_smart/core/utils/appColor.dart';

class DoctorSearchField extends StatelessWidget {
  final Function(String) onChanged;

  const DoctorSearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        hintText: 'Search doctors by name or specialization',
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.kprimaryColor500,
            width: 2,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}