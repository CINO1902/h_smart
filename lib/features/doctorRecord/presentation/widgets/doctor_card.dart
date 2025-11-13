import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ?? () {
          context.push('/doctor/detail', extra: {"doctor": doctor});
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Doctor Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.kprimaryColor500.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: doctor.profileUrl != null &&
                          doctor.profileUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: doctor.profileUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.kprimaryColor500.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.kprimaryColor500,
                              size: 30,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.kprimaryColor500.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.kprimaryColor500,
                              size: 30,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.kprimaryColor500,
                          size: 30,
                        ),
                ),
              ),
              const Gap(16),
              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(4),
                    if (doctor.specialization != null) ...[
                      Text(
                        doctor.specialization!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kprimaryColor500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(4),
                    ],
                    if (doctor.experienceYears != null) ...[
                      Text(
                        '${doctor.experienceYears} years experience',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}