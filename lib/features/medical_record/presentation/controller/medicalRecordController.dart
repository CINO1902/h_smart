import 'package:flutter/material.dart';
import 'package:h_smart/features/medical_record/domain/entities/GetOverView.dart';
import 'package:h_smart/features/medical_record/domain/entities/prescription.dart';
import 'package:h_smart/features/medical_record/domain/repositories/MedicalRecord_repo.dart';
import 'package:h_smart/features/medical_record/domain/usecases/userStates.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/appointmentBooking.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:intl/intl.dart';

class MedicalRecordprovider extends ChangeNotifier {
  final MedicalRecordRepo medicalRecordRepo;

  MedicalRecordprovider(this.medicalRecordRepo);

  bool isUpdating = false;
  bool listloaded = false;

  GetOverResult overview =
      GetOverResult(status: GetOverResultStates.idle, data: GetOverView());
  GetPrescriptionResult prescription = GetPrescriptionResult(
      GetPrescriptionResultStates.loading, PescriptionResponse());

  Future<void> getprescription() async {
    if (listloaded) {
      isUpdating = true;
      notifyListeners();
    } else {
      prescription = GetPrescriptionResult(
          GetPrescriptionResultStates.loading, PescriptionResponse());
      notifyListeners();
    }
    final response = await medicalRecordRepo.getprescription();
    prescription = response;
    isUpdating = false;
    if (response.status == GetPrescriptionResultStates.success) {
      listloaded = true;
    }
    notifyListeners();
  }

  Future<void> getOverview() async {
    overview =
        GetOverResult(status: GetOverResultStates.loading, data: GetOverView());
    notifyListeners();
    final response = await medicalRecordRepo.getOverview();
    print(response);
    overview = response;
    notifyListeners();
  }
  
  // Add a new appointment to the overview's appointments list
  void addNewAppointment(AppointmentBookingData appointmentData, Doctor doctor) {
    if (overview.status == GetOverResultStates.success && 
        overview.data.payload != null) {
      
      // Ensure appointments list is initialized
      if (overview.data.payload!.appointments == null) {
        overview.data.payload!.appointments = [];
      }
      
      // Format the appointment time from ISO string
      final appointmentTime = _formatTimeFromISOString(appointmentData.slotBookedStartTime);
      
      // Create a new appointment object with proper DateTime objects
      final newAppointment = Appointment(
        id: appointmentData.id,
        doctorName: "${doctor.firstName ?? ''} ${doctor.lastName ?? ''}".trim(),
        doctorSpecialization: doctor.specialization ?? '',
        date: DateTime.tryParse(appointmentData.slotBookedStartTime),
        time: appointmentTime,
        status: appointmentData.status,
        createdAt: DateTime.tryParse(appointmentData.createdAt),
      );
      
      // Add the new appointment to the list
      overview.data.payload!.appointments!.add(newAppointment);
      
      // Notify listeners about the change
      notifyListeners();
    }
  }
  
  // Helper method to format time from ISO string
  String _formatTimeFromISOString(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat('h:mm a').format(dateTime.toLocal());
    } catch (e) {
      return '';
    }
  }
}
