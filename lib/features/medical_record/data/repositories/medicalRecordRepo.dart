import '../../domain/usecases/userStates.dart';

abstract class MedicalRecordDatasource {
  Future<List<dynamic>> getprescription();
  Future<GetOverResult> getOverview();
}
