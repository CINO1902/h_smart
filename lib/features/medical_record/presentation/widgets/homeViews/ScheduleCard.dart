import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../../../core/utils/appColor.dart';

class ScheduleCard extends StatelessWidget {
  final List<dynamic>? appointments;
  final PageController appointmentController;
  final int currentAppointmentIndex;
  final ValueChanged<int> onPageChanged;

  const ScheduleCard({
    super.key,
    required this.appointments,
    required this.appointmentController,
    required this.currentAppointmentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments == null || (appointments?.isEmpty ?? true)) {
      // Show empty state
      return SizedBox(
        height: 180,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor100,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/up.svg',
                width: 48,
                height: 48,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/down.svg',
                width: 48,
                height: 48,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white,
                          size: 16,
                        ),
                        Gap(6),
                        Text(
                          'Upcoming Schedule',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    'No upcoming appointments',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Book your next appointment',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sideMargin = width * 0.03;
        final svgSize = width * 0.3;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kprimaryColor500,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/up.svg',
                width: svgSize,
                height: svgSize,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/down.svg',
                width: svgSize,
                height: svgSize,
              ),
            ),
            PageView.builder(
              controller: appointmentController,
              onPageChanged: onPageChanged,
              itemCount: appointments!.length,
              itemBuilder: (context, index) {
                final appointment = appointments![index];
                final appointmentDate = appointment.date;
                final appointmentTime = appointment.time;

                String formattedDate = 'No date set';
                String formattedTime = 'No time set';

                if (appointmentDate != null) {
                  formattedDate =
                      '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}';
                }

                if (appointmentTime != null) {
                  formattedTime = appointmentTime;
                }

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const Gap(6),
                                Text(
                                  'Appointment ${index + 1} of ${appointments!.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Text(
                        appointment.doctorName ?? 'Doctor Name',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment.doctorSpecialization ?? 'Specialization',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const Gap(6),
                                Text(
                                  '$formattedDate, $formattedTime',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(appointment.status)
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              appointment.status ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            if (appointments!.length > 1)
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    appointments!.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentAppointmentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

Color _getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'confirmed':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'cancelled':
      return Colors.red;
    case 'completed':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}
