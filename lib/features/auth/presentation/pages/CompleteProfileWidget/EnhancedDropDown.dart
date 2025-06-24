import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:h_smart/core/utils/appColor.dart';

class EnhancedDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const EnhancedDropdown({
    Key? key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: GestureDetector(
        onTap: () async {
          final selectedValue = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) {
              final screenHeight = MediaQuery.of(ctx).size.height;
              final estimatedHeight = 120 + (items.length * 56);
              final minHeight = screenHeight * 0.2;
              final maxHeight = screenHeight * 0.5;
              final modalHeight =
                  estimatedHeight.clamp(minHeight, maxHeight).toDouble();

              return Container(
                height: modalHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Select $label',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: value == item
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.kprimaryColor500,
                                  )
                                : null,
                            onTap: () => Navigator.pop(ctx, item),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );

          if (selectedValue != null) {
            onChanged(selectedValue);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: value != null
                  ? AppColors.kprimaryColor500.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kprimaryColor500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  label == 'Gender'
                      ? Icons.person_outline
                      : Icons.bloodtype_outlined,
                  color: AppColors.kprimaryColor500,
                  size: 20,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                    ),
                    const Gap(2),
                    Text(
                      value ?? 'Select $label',
                      style: TextStyle(
                        color: value == null
                            ? Colors.grey[400]
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight:
                            value == null ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
