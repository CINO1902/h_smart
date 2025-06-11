import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/DoctorsResponse.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/Hospital/domain/states/hospitalStates.dart';
import 'package:shimmer/shimmer.dart';

class DoctorsSection extends StatelessWidget {
  final DoctorsResponse? doctorsResponse;
  final DoctorResultStates doctorResultStates;
  final VoidCallback onRetry;

  const DoctorsSection({
    super.key,
    this.doctorsResponse,
    required this.doctorResultStates,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (doctorResultStates == DoctorResultStates.isLoading) {
      return _buildLoadingState();
    }

    if (doctorResultStates == DoctorResultStates.isError ||
        doctorResultStates == DoctorResultStates.isEmpty ||
        doctorResultStates == DoctorResultStates.isTimedOut ||
        doctorResultStates == DoctorResultStates.noNetWork) {
      return _buildErrorState();
    }

    if (doctorResultStates == DoctorResultStates.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Doctors',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(15),
        ...doctorsResponse?.doctors
                ?.map((doctor) => _buildDoctorItem(doctor, context))
                .toList() ??
            [],
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Doctors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(15),
        ...List.generate(3, (index) => _buildShimmerDoctorItem()),
      ],
    );
  }

  Widget _buildShimmerDoctorItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    String message;
    IconData icon;

    if (doctorResultStates == DoctorResultStates.isTimedOut) {
      message = 'Request timed out. Please try again.';
      icon = Icons.timer_outlined;
    } else if (doctorResultStates == DoctorResultStates.noNetWork) {
      message = 'No internet connection. Please check your network.';
      icon = Icons.wifi_off;
    } else if (doctorResultStates == DoctorResultStates.isEmpty) {
      message = 'No doctors found for this hospital.';
      icon = Icons.people_outline;
    } else {
      message = 'Something went wrong. Please try again.';
      icon = Icons.error_outline;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Doctors',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(15),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: AppColors.kprimaryColor500,
              ),
              const Gap(12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kprimaryColor500,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Doctors',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(15),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.medical_services,
                size: 40,
                color: AppColors.kprimaryColor500,
              ),
              const Gap(12),
              Text(
                'Doctor information will be available soon',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'We are currently setting up our doctors database',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorItem(Doctor doctor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/doctor/detail', extra: {"doctor": doctor});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.kprimaryColor500.withOpacity(0.1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  imageUrl: doctor.profileUrl ?? '',
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.kprimaryColor500,
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${doctor.fullName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    doctor.specialization ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '${doctor.qualification} • ${doctor.experienceYears} years exp.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.kprimaryColor500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
