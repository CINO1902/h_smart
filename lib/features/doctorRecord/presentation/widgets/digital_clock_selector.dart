import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'booking_confirmation_modal.dart';

class AvailabilitySlot {
  final String id;
  final String dayOfWeek;
  final List<String> startTime;
  final bool allowslotbetweenbreak;
  final List<String> endTime;
  final String doctorName;
  final List<String> chosenTime;
  final String sessionTime;
  final String hospitalName;

  AvailabilitySlot({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.allowslotbetweenbreak,
    required this.endTime,
    required this.sessionTime,
    required this.chosenTime,
    required this.doctorName,
    required this.hospitalName,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json['id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      allowslotbetweenbreak: json['allowslotbetweenbreak'],
      endTime: json['end_time'],
      chosenTime: json['chosen_time'],
      sessionTime: json['session_time'],
      doctorName: json['doctor_name'],
      hospitalName: json['hospital_name'],
    );
  }
}

class DigitalClockSelector extends StatefulWidget {
  final Function(String, String, String)
      onTimeSelected; // Changed to include slot ID
  final List<AvailabilitySlot> availableSlots;
  final Doctor doctor;

  const DigitalClockSelector({
    super.key,
    required this.onTimeSelected,
    required this.availableSlots,
    required this.doctor,
  });

  @override
  State<DigitalClockSelector> createState() => _DigitalClockSelectorState();
}

class _DigitalClockSelectorState extends State<DigitalClockSelector> {
  String? _selectedSlotId;
  Set<String> _selectedTimeSlots = {};
  late Map<String, List<AvailabilitySlot>> _groupedSlots;

  @override
  void initState() {
    super.initState();
    _groupSlotsByDay();
  }

  void _groupSlotsByDay() {
    _groupedSlots = <String, List<AvailabilitySlot>>{};
    for (var slot in widget.availableSlots) {
      final day = _capitalizeDay(slot.dayOfWeek);
      if (_groupedSlots[day] == null) {
        _groupedSlots[day] = [];
      }
      _groupedSlots[day]!.add(slot);
    }
  }

  String _capitalizeDay(String day) {
    if (day.isEmpty) return day;
    return day[0].toUpperCase() + day.substring(1).toLowerCase();
  }

  String _formatTime(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  List<String> _generateTimeSlots(List<String> startTimes,
      List<String> endTimes, String sessionTime, List<String> chosenTimes) {
    List<String> allSlots = [];

    // Parse session time to get interval in minutes
    int intervalMinutes = _parseSessionTime(sessionTime);

    for (int i = 0; i < startTimes.length && i < endTimes.length; i++) {
      final start = TimeOfDay(
        hour: int.parse(startTimes[i].split(':')[0]),
        minute: int.parse(startTimes[i].split(':')[1]),
      );
      final end = TimeOfDay(
        hour: int.parse(endTimes[i].split(':')[0]),
        minute: int.parse(endTimes[i].split(':')[1]),
      );

      int currentHour = start.hour;
      int currentMinute = start.minute;

      while (currentHour < end.hour ||
          (currentHour == end.hour && currentMinute < end.minute)) {
        final timeString =
            '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}:00';

        // Add all time slots (including chosen ones)
        allSlots.add(timeString);

        currentMinute += intervalMinutes;
        if (currentMinute >= 60) {
          currentHour += currentMinute ~/ 60;
          currentMinute = currentMinute % 60;
        }
      }
    }

    return allSlots;
  }

  int _parseSessionTime(String sessionTime) {
    // Parse session time like "30 minutes", "1 hour", etc.
    final lowerCase = sessionTime.toLowerCase();
    if (lowerCase.contains('hour')) {
      final hourMatch = RegExp(r'(\d+)\s*hour').firstMatch(lowerCase);
      if (hourMatch != null) {
        return int.parse(hourMatch.group(1)!) * 60;
      }
    } else if (lowerCase.contains('minute')) {
      final minuteMatch = RegExp(r'(\d+)\s*minute').firstMatch(lowerCase);
      if (minuteMatch != null) {
        return int.parse(minuteMatch.group(1)!);
      }
    }
    return 30; // Default to 30 minutes
  }

  bool _wouldSpanAcrossChosenTime(String newTimeSlot, List<String> chosenTimes,
      Set<String> currentlySelected) {
    if (chosenTimes.isEmpty) return false;

    // Create a set of all potentially selected times (current + new)
    final allSelected = Set<String>.from(currentlySelected);
    allSelected.add(newTimeSlot);

    // Sort all selected times
    final sortedSelected = allSelected.toList()..sort();

    // Check if any chosen time falls between the min and max selected times
    if (sortedSelected.length < 2) return false;

    final minSelected = sortedSelected.first;
    final maxSelected = sortedSelected.last;

    for (final chosenTime in chosenTimes) {
      if (chosenTime.compareTo(minSelected) > 0 &&
          chosenTime.compareTo(maxSelected) < 0) {
        return true;
      }
    }

    return false;
  }

  bool _wouldSpanAcrossBreak(String newTimeSlot, AvailabilitySlot slot,
      Set<String> currentlySelected) {
    if (slot.allowslotbetweenbreak) return false;

    // Create a set of all potentially selected times (current + new)
    final allSelected = Set<String>.from(currentlySelected);
    allSelected.add(newTimeSlot);

    // Sort all selected times
    final sortedSelected = allSelected.toList()..sort();

    if (sortedSelected.length < 2) return false;

    final minSelected = sortedSelected.first;
    final maxSelected = sortedSelected.last;

    // Check if selection spans across different time periods (break)
    for (int i = 0; i < slot.startTime.length; i++) {
      final periodStart = slot.startTime[i];
      final periodEnd = slot.endTime[i];

      // Check if min and max selected times are in different periods
      final minInThisPeriod = minSelected.compareTo(periodStart) >= 0 &&
          minSelected.compareTo(periodEnd) <= 0;
      final maxInThisPeriod = maxSelected.compareTo(periodStart) >= 0 &&
          maxSelected.compareTo(periodEnd) <= 0;

      if (minInThisPeriod && !maxInThisPeriod) {
        return true; // Spans across break
      }
      if (!minInThisPeriod && maxInThisPeriod) {
        return true; // Spans across break
      }
    }

    return false;
  }

  void _fillMissingTimeSlots(
      List<String> availableTimeSlots, List<String> chosenTimes) {
    if (_selectedTimeSlots.length < 2) return;

    // Sort selected time slots
    final sortedSelected = _selectedTimeSlots.toList()..sort();
    final minTime = sortedSelected.first;
    final maxTime = sortedSelected.last;

    // Find all time slots between min and max that are available and not chosen
    for (final timeSlot in availableTimeSlots) {
      if (timeSlot.compareTo(minTime) > 0 &&
          timeSlot.compareTo(maxTime) < 0 &&
          !chosenTimes.contains(timeSlot)) {
        _selectedTimeSlots.add(timeSlot);
      }
    }
  }

  void _removeSlotAndFollowing(
      String timeSlot, List<String> availableTimeSlots) {
    // Sort available time slots to determine order
    final sortedAvailable = availableTimeSlots.toList()..sort();
    final slotIndex = sortedAvailable.indexOf(timeSlot);

    if (slotIndex == -1) return;

    // Remove the selected slot and all slots that come after it
    final slotsToRemove = <String>{};
    for (int i = slotIndex; i < sortedAvailable.length; i++) {
      if (_selectedTimeSlots.contains(sortedAvailable[i])) {
        slotsToRemove.add(sortedAvailable[i]);
      }
    }

    _selectedTimeSlots.removeAll(slotsToRemove);
  }

  void _showBookingConfirmationModal(
    BuildContext context,
    AvailabilitySlot selectedSlot,
    List<String> selectedTimes,
    String formattedTimes,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BookingConfirmationModal(
          selectedSlot: selectedSlot,
          selectedTimes: selectedTimes,
          formattedTimes: formattedTimes,
          doctor: widget.doctor,
          onConfirm: () {
            widget.onTimeSelected(
              selectedSlot.dayOfWeek,
              formattedTimes,
              selectedSlot.sessionTime,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availableSlots.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No available time slots',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _groupedSlots.entries.map((entry) {
                final day = entry.key;
                final slots = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    ...slots.map((slot) => _buildSlotCard(slot)),
                    const Gap(16),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const Gap(20),
        if (_selectedSlotId != null && _selectedTimeSlots.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              final selectedSlot = widget.availableSlots.firstWhere(
                (slot) => slot.id == _selectedSlotId,
              );

              // Format selected time slots for display
              final selectedTimes = _selectedTimeSlots.toList()..sort();
              final formattedTimes =
                  selectedTimes.map((time) => _formatTime(time)).join(', ');

              _showBookingConfirmationModal(
                context,
                selectedSlot,
                selectedTimes,
                formattedTimes,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirm Booking',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSlotCard(AvailabilitySlot slot) {
    final isSelected = _selectedSlotId == slot.id;
    final timeSlots = _generateTimeSlots(
        slot.startTime, slot.endTime, slot.sessionTime, slot.chosenTime);

    // Create time range display
    final timeRanges = <String>[];
    for (int i = 0; i < slot.startTime.length && i < slot.endTime.length; i++) {
      timeRanges.add(
          '${_formatTime(slot.startTime[i])} - ${_formatTime(slot.endTime[i])}');
    }
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSlotId = null;
                  _selectedTimeSlots.clear();
                } else {
                  _selectedSlotId = slot.id;
                  _selectedTimeSlots.clear(); // Clear previous selections
                }
              });
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Sessions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.blue
                        : isDark
                            ? Colors.white
                            : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const Gap(4),
                ...timeRanges.map((range) => Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        range,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.blue.withValues(alpha: 0.8)
                              : isDark
                                  ? Colors.white
                                  : Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                slot.hospitalName,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          if (isSelected && timeSlots.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Time Slots (${slot.sessionTime} intervals):',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: timeSlots.map((timeSlot) {
                      final isChosen = slot.chosenTime.contains(timeSlot);
                      final isSelected = _selectedTimeSlots.contains(timeSlot);

                      return GestureDetector(
                        onTap: isChosen
                            ? null
                            : () {
                                // Check if selecting this time slot would span across breaks
                                if (!isSelected &&
                                    _wouldSpanAcrossBreak(
                                        timeSlot, slot, _selectedTimeSlots)) {
                                  SnackBarService.showSnackBar(
                                    context,
                                    title: 'Invalid Selection',
                                    body:
                                        'Cannot select time slots across break periods',
                                    status: SnackbarStatus.fail,
                                  );
                                  return;
                                }

                                // Check if selecting this time slot would span across chosen times
                                if (!isSelected &&
                                    _wouldSpanAcrossChosenTime(timeSlot,
                                        slot.chosenTime, _selectedTimeSlots)) {
                                  // Move to the new slot and clear previous selections
                                  SnackBarService.showSnackBar(
                                    context,
                                    title: 'Invalid Selection',
                                    body:
                                        'Cannot select time slots across chosen time slots',
                                    status: SnackbarStatus.fail,
                                  );
                                  setState(() {
                                    _selectedTimeSlots.clear();
                                    _selectedTimeSlots.add(timeSlot);
                                  });
                                  return;
                                }

                                setState(() {
                                  if (isSelected) {
                                    // When deselecting, remove this slot and all slots after it to maintain continuity
                                    _removeSlotAndFollowing(
                                        timeSlot, timeSlots);
                                  } else {
                                    _selectedTimeSlots.add(timeSlot);
                                    // Auto-fill missing time slots to ensure continuous booking
                                    _fillMissingTimeSlots(
                                        timeSlots, slot.chosenTime);
                                  }
                                });
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isChosen
                                ? Colors.grey.withValues(alpha: 0.2)
                                : isSelected
                                    ? Colors.blue.withValues(alpha: 0.3)
                                    : Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isChosen
                                  ? Colors.grey.withValues(alpha: 0.5)
                                  : isSelected
                                      ? Colors.blue
                                      : Colors.blue.withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            _formatTime(timeSlot),
                            style: TextStyle(
                              fontSize: 12,
                              color: isChosen
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.blue
                                      : Colors.blue,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              decoration:
                                  isChosen ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
