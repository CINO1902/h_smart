import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MedicalInfo extends StatefulWidget {
  const MedicalInfo({super.key});

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0.1,
        title: Text(
          'Medical Info',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Allergies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(10),
              height: 125,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Food (Peanuts)',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Drug (Penicillin)',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Text(
              'Medical Conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(10),
              height: 125,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Asthma',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Diabetes Type 2',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Text(
              'Blood Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(10),
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'O+',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
