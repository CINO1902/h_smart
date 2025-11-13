import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'digital_clock_selector.dart';

class TimeSlot extends StatelessWidget {
  final DateTime date;
  final ThemeData theme;
  final VoidCallback onTimeSlotTap;
  final List<AvailabilitySlot> availableSlots;
  final Doctor doctor;

  const TimeSlot({
    super.key,
    required this.date,
    required this.theme,
    required this.onTimeSlotTap,
    required this.doctor,
    this.availableSlots = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isToday = date.day == DateTime.now().day;
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    
    // Check if there are available slots for this specific day
    final dayOfWeek = _getDayOfWeekString(date.weekday);
    final hasAvailableSlots = availableSlots.any((slot) => 
        slot.dayOfWeek.toLowerCase() == dayOfWeek.toLowerCase());
    final isAvailable = !isWeekend && hasAvailableSlots;

    return Container(
      decoration: BoxDecoration(
        color: isToday
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.2),
          width: isToday ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isAvailable) {
                // Filter slots for this specific day
                final daySlots = availableSlots.where((slot) => 
                    slot.dayOfWeek.toLowerCase() == dayOfWeek.toLowerCase()).toList();
                showTimeSelectionDialog(context, date, theme, daySlots, doctor);
              }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getDayName(date.weekday),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    if (isToday)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(4),
                Text(
                  '${date.day} ${_getMonthName(date.month)}',
                  style: TextStyle(
                    color: isWeekend
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
                        : theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const Gap(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Not Available',
                    style: TextStyle(
                      color: isAvailable
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String _getDayOfWeekString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}

// Helper function to show time selection dialog
void showTimeSelectionDialog(
    BuildContext context, 
    DateTime date, 
    ThemeData theme, 
    List<AvailabilitySlot> availableSlots,
    Doctor doctor) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Available Time Slot',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                DigitalClockSelector(
                  availableSlots: availableSlots,
                  doctor: doctor,
                  onTimeSelected: (timeRange, slotId, sessionTime) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appointment booked for $timeRange (Session: $sessionTime)'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}