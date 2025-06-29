import 'package:flutter/material.dart';
import 'package:h_smart/features/medical_record/domain/entities/GetOverView.dart';
import 'package:h_smart/features/medical_record/domain/entities/prescription.dart';
import 'package:h_smart/features/medical_record/domain/repositories/MedicalRecord_repo.dart';
import 'package:h_smart/features/medical_record/domain/usecases/userStates.dart';

class MedicalRecordprovider extends ChangeNotifier {
  final MedicalRecordRepo medicalRecordRepo;

  MedicalRecordprovider(this.medicalRecordRepo);

  bool isUpdating = false;
  bool listloaded = false;

  GetOverResult overview =
      GetOverResult(status: GetOverResultStates.loading, data: GetOverView());
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
    overview = response;
    notifyListeners();
  }
}
