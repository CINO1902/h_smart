import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/medical_record/domain/entities/userDetailsModel.dart';

class HealthSummaryCard extends StatelessWidget {
  final PatientMetadata? patientMetadata;
  final VoidCallback? onTap;

  const HealthSummaryCard({
    super.key,
    this.patientMetadata,
    this.onTap,
  });

  List<String> _processAllergies(List<String>? allergies) {
    if (allergies == null) return [];

    List<String> processedAllergies = [];
    for (String item in allergies) {
      if (item.contains(',')) {
        // Split comma-separated values
        processedAllergies.addAll(
            item.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
      } else {
        processedAllergies.add(item);
      }
    }
    return processedAllergies;
  }

  List<String> _processMedicalConditions(List<String>? medicalConditions) {
    if (medicalConditions == null) return [];

    List<String> processedConditions = [];
    for (String item in medicalConditions) {
      if (item.contains(',')) {
        // Split comma-separated values
        processedConditions.addAll(
            item.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
      } else {
        processedConditions.add(item);
      }
    }
    return processedConditions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.blue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.green.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.health_and_safety_outlined,
                    color: Colors.green.shade600,
                    size: 24,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'View and manage your health information',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.iconTheme.color?.withOpacity(0.4),
                ),
              ],
            ),
            const Gap(20),

            // Health stats grid
            Row(
              children: [
                Expanded(
                  child: _buildHealthStat(
                    icon: Icons.favorite,
                    label: 'Blood Type',
                    value: patientMetadata?.bloodType ?? 'Not set',
                    color: Colors.red,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: _buildHealthStat(
                    icon: Icons.warning,
                    label: 'Allergies',
                    value: _processAllergies(patientMetadata?.allergies)
                            .isNotEmpty
                        ? '${_processAllergies(patientMetadata?.allergies).length} items'
                        : 'None',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _buildHealthStat(
                    icon: Icons.medical_services,
                    label: 'Conditions',
                    value: _processMedicalConditions(
                                patientMetadata?.medicalConditions)
                            .isNotEmpty
                        ? '${_processMedicalConditions(patientMetadata?.medicalConditions).length} items'
                        : 'None',
                    color: Colors.purple,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: _buildHealthStat(
                    icon: Icons.contact_emergency,
                    label: 'Emergency',
                    value: patientMetadata?.emergencyContactName?.isNotEmpty ==
                            true
                        ? 'Set'
                        : 'Not set',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
