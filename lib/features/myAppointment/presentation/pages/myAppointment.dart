import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/appColor.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({super.key});

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this)
    ..addListener(() {
      setState(() {});
    });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
          centerTitle: false,
          leading: null,
          elevation: 0,
          titleSpacing: 0.1,
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          titleTextStyle: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'My Appointments',
              style: TextStyle(
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
          )),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 50,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.colorScheme.onSecondaryFixedVariant,
              ),
              child: Row(
                // fixed two children is easier than ListView here
                children: [
                  _TabButton(
                    label: 'Upcoming',
                    isSelected: controller.index == 0,
                    onTap: () => controller.animateTo(0),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                  ),
                  _TabButton(
                    label: 'Past',
                    isSelected: controller.index == 1,
                    onTap: () => controller.animateTo(1),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(controller: controller, children: [
                ListView(
                  children: [
                    const Gap(20),
                    _buildAppointmentCard(
                      context,
                      'Dr. Alis William',
                      '12th, July 2023',
                      'Upcoming',
                      theme.colorScheme.tertiary,
                    ),
                  ],
                ),
                ListView(
                  children: [
                    const Gap(20),
                    _buildAppointmentCard(
                      context,
                      'Dr. Alis William',
                      '12th, July 2023',
                      'Completed',
                      theme.colorScheme.primary,
                    ),
                    const Gap(10),
                    _buildAppointmentCard(
                      context,
                      'Dr. Alis William',
                      '12th, July 2023',
                      'Cancelled',
                      theme.colorScheme.error,
                    ),
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    String doctorName,
    String date,
    String status,
    Color statusColor,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'images/doctorimage.png',
                  ),
                ),
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    doctorName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/Clock.png',
                        height: 10,
                        width: 10,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const Gap(5),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 9,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
            ),
          )
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius, // InkWell ripple clipped to this
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant.withOpacity(.3),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: isSelected
                ? theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimary,
                  )
                : theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(.7),
                  ),
          ),
        ),
      ),
    );
  }
}
