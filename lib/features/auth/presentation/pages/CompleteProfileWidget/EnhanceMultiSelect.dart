import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:h_smart/core/utils/appColor.dart';

import '../../../../../core/theme/theme_mode_provider.dart';

class EnhancedMultiSelect extends ConsumerWidget {
  final String label;
  final List<String> options;
  final List<String> selected;
  final void Function(List<String?>) onConfirm;

  const EnhancedMultiSelect({
    Key? key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Convert selected List<String> -> List<String?>
    final initial = selected.cast<String?>();
    final isDarkMode = ref.read(themeModeCheckerProvider)(context);
    return Container(
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
      child: MultiSelectBottomSheetField<String?>(
        selectedColor: AppColors.kprimaryColor500,
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.6,
        listType: MultiSelectListType.LIST,
        items: options.map((e) => MultiSelectItem<String?>(e, e)).toList(),
        title: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kprimaryColor500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  label == 'Allergies'
                      ? Icons.warning_outlined
                      : Icons.medical_services_outlined,
                  color: AppColors.kprimaryColor500,
                  size: 20,
                ),
              ),
              const Gap(12),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        buttonText: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        initialValue: initial,
        itemsTextStyle: Theme.of(context).textTheme.bodyLarge,
        selectedItemsTextStyle: const TextStyle(
          color: AppColors.kprimaryColor500,
          fontWeight: FontWeight.w600,
        ),
        unselectedColor: Colors.grey[400],
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected.isNotEmpty
                ? AppColors.kprimaryColor500.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        onConfirm: (List<String?> values) {
          onConfirm(values);
        },
        chipDisplay: MultiSelectChipDisplay(
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.kprimaryColor500.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          chipColor: isDarkMode
              ? AppColors.kprimaryColor500.withOpacity(0.1)
              : AppColors.kprimaryColor500.withOpacity(0.4),
          textStyle: const TextStyle(
            color: AppColors.kprimaryColor600,
            fontWeight: FontWeight.w500,
          ),
          onTap: (val) {
            final updated = List<String?>.from(initial)..remove(val);
            onConfirm(updated);
          },
        ),
      ),
    );
  }
}
