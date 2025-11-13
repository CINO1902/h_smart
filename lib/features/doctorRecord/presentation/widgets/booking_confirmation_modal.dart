import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/appointmentBooking.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:h_smart/features/doctorRecord/domain/usecases/doctorStates.dart';
import 'package:h_smart/features/medical_record/presentation/controller/medicalRecordController.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import '../provider/doctorprovider.dart';
import 'digital_clock_selector.dart';

class BookingConfirmationModal extends ConsumerStatefulWidget {
  final AvailabilitySlot selectedSlot;
  final List<String> selectedTimes;
  final String formattedTimes;
  final Doctor doctor;
  final VoidCallback onConfirm;

  const BookingConfirmationModal({
    super.key,
    required this.selectedSlot,
    required this.selectedTimes,
    required this.formattedTimes,
    required this.doctor,
    required this.onConfirm,
  });

  @override
  ConsumerState<BookingConfirmationModal> createState() => _BookingConfirmationModalState();
}

class _BookingConfirmationModalState extends ConsumerState<BookingConfirmationModal> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _typeController = TextEditingController(text: 'consultation');
  bool _isBooking = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  String _convertToISOFormat(String timeSlot, DateTime selectedDate) {
    final parts = timeSlot.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );
    
    return dateTime.toUtc().toIso8601String();
  }

  Future<void> _handleBooking() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reason for the appointment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      final doctorProvider = ref.read(doctorprovider);
      
      // Get the selected date (assuming today for now, you might want to pass this from the parent)
      final selectedDate = DateTime.now();
      
      // Convert start and end times to ISO format
      final startTime = _convertToISOFormat(widget.selectedTimes.first, selectedDate);
      final endTime = _convertToISOFormat(widget.selectedTimes.last, selectedDate);
      
      final request = AppointmentBookingRequest(
        doctorsAppointmentsId: widget.selectedSlot.id,
        doctorId: widget.doctor.userId ?? '',
        slotBookedStartTime: startTime,
        slotBookedEndTime: endTime,
        reason: _reasonController.text.trim(),
        type: _typeController.text.trim(),
      );
      
      await doctorProvider.bookAppointment(request);
      
      if (mounted) {
        final result = doctorProvider.appointmentBookingResult;
          
        if (result.state == AppointmentBookingResultState.isData) {
          // Update the medical record with the new appointment
          final recordProvider = ref.read(medicalRecordProvider);
          recordProvider.addNewAppointment(
            result.response.data,
            widget.doctor
          );
          
          // Close the modal first
          Navigator.of(context).pop();
          
          // Show success notification
          SnackBarService.notifyAction(
            context,
            message: result.response.message ?? 'Appointment booked successfully!',
            status: SnackbarStatus.success,
          );
          
          // Call the onConfirm callback
          widget.onConfirm();
        } else {
          SnackBarService.notifyAction(
            context,
            message: result.response.message ?? 'Failed to book appointment',
            status: SnackbarStatus.fail,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarService.notifyAction(
          context,
          message: 'Error: $e',
          status: SnackbarStatus.fail,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
          maxWidth: 400,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  // Header with icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                  const Gap(16),
                  // Title
                  Text(
                    'Confirm Your Appointment',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(4),
                  Text(
                    'Please review your booking details',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                   children: [

                    // Doctor and Hospital Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? colorScheme.surfaceContainerHighest
                            : colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.selectedSlot.doctorName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: Colors.orange.shade600,
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hospital',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.selectedSlot.hospitalName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                    ),
                    const Gap(16),

                    // Appointment Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3)),
                      ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: colorScheme.onPrimaryContainer,
                            size: 18,
                          ),
                          const Gap(8),
                          Text(
                            'Day',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.selectedSlot.dayOfWeek,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: colorScheme.onPrimaryContainer,
                            size: 18,
                          ),
                          const Gap(8),
                          Text(
                            'Duration',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.selectedSlot.sessionTime,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                    ),
                    const Gap(16),

                    // Sessions Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green.shade900.withValues(alpha: 0.2) : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.selectedTimes.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Text(
                        'Sessions Booked',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.onSurface : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: Colors.green.shade600,
                          size: 16,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            widget.formattedTimes,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                    ),
                    const Gap(20),

                    // Reason Input Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason for Appointment',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          controller: _reasonController,
                          decoration: InputDecoration(
                            hintText: 'Enter reason for appointment',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Fixed Footer with Action Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isBooking ? null : _handleBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isBooking)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.check_circle_rounded,
                              size: 20,
                              color: colorScheme.onPrimary,
                            ),
                          const Gap(8),
                          Text(
                            _isBooking ? 'Booking...' : 'Confirm Booking',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
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

  static void show({
    required BuildContext context,
    required AvailabilitySlot selectedSlot,
    required List<String> selectedTimes,
    required String formattedTimes,
    required Doctor doctor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BookingConfirmationModal(
          selectedSlot: selectedSlot,
          selectedTimes: selectedTimes,
          formattedTimes: formattedTimes,
          doctor: doctor,
          onConfirm: onConfirm,
        );
      },
    );
  }
}
