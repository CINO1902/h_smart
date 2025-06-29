import '../../domain/usecases/userStates.dart';

abstract class MedicalRecordDatasource {
  Future<GetPrescriptionResult> getprescription();
  Future<GetOverResult> getOverview();
}
