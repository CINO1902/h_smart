import 'package:h_smart/features/medical_record/domain/entities/GetOverView.dart';

import '../entities/prescription.dart';

class GetOverResult {
  final GetOverResultStates status;

  final GetOverView data;

  GetOverResult({required this.status, required this.data});
}

enum GetOverResultStates {
  success,
  idle,
  fail,
  loading,
}

class GetPrescriptionResult {
  final GetPrescriptionResultStates status;

  final PescriptionResponse data;

  GetPrescriptionResult(this.status, this.data);
}

enum GetPrescriptionResultStates {
  success,
  idle,
  fail,
  loading,
}
