import '../../domain/states/hospitalStates.dart';

abstract class HospitalDataSource {
  Future<HospitalResult> getHospital();
  Future<HospitalResult> getMoreSpecificHospital(ownnershiptype, page);
      Future<HospitalResult> searchHospital(search);
      Future<DoctorResult> GetDoctorsByHospitalId(hospitalId);
}
