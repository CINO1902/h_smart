import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/domain/entities/prescription.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/appColor.dart';
import '../separator.dart';

class EnhancedPrescriptionCard extends StatefulWidget {
  final Pescription prescription;
  final int index;

  const EnhancedPrescriptionCard({
    super.key,
    required this.prescription,
    required this.index,
  });

  @override
  State<EnhancedPrescriptionCard> createState() =>
      _EnhancedPrescriptionCardState();
}

class _EnhancedPrescriptionCardState extends State<EnhancedPrescriptionCard> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    final prescription = widget.prescription;
    final medications = prescription.medications ?? [];
    final startDate = prescription.startDate;
    final endDate = prescription.endDate;
    final status = prescription.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header with status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status?.toUpperCase() ?? 'UNKNOWN',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Prescribed by: Dr. ${prescription.doctorName ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                ),
              ],
            ),
          ),

          // Medications List
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medications (${medications.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                ),
                const Gap(12),
                if (medications.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const Gap(8),
                        Text(
                          'No medications prescribed',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final medication = medications[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.kprimaryColor500.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.kprimaryColor500.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    medication.name ?? 'Unknown Medication',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.kprimaryColor500
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    medication.dosage ?? 'N/A',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.kprimaryColor500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            if (medication.frequency != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  const Gap(4),
                                  Text(
                                    'Frequency: ${medication.frequency}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.color,
                                        ),
                                  ),
                                ],
                              ),
                              const Gap(4),
                            ],
                            if (medication.instructions != null) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  const Gap(4),
                                  Expanded(
                                    child: Text(
                                      'Instructions: ${medication.instructions}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.color,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const MySeparator(),
          // Footer with dates and expand button
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (startDate != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const Gap(4),
                            Text(
                              'Start: ${DateFormat('MMM dd, yyyy').format(startDate)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.color,
                                  ),
                            ),
                          ],
                        ),
                        const Gap(4),
                      ],
                      if (endDate != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 16,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const Gap(4),
                            Text(
                              'End: ${DateFormat('MMM dd, yyyy').format(endDate)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.color,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.kprimaryColor500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      showDetails ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.kprimaryColor500,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expandable doctor details
          if (showDetails)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.kprimaryColor500.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: prescription.doctorProfileUrl != null
                          ? CachedNetworkImage(
                              imageUrl: prescription.doctorProfileUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            )
                          : Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${prescription.doctorName ?? 'Unknown'}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color,
                                  ),
                        ),
                        const Gap(4),
                        if (prescription.phoneNumber != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              const Gap(4),
                              Text(
                                prescription.phoneNumber!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
