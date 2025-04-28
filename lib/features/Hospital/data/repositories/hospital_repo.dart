import '../../domain/states/hospitalStates.dart';

abstract class HospitalDataSource {
 Future<HospitalResult> getHospital();
}
