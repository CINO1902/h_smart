import '../../domain/usecases/doctorStates.dart';

abstract class DoctorDatasource {
  Future<GetDoctorListResult> getDoctorList();
  Future<List<dynamic>> getDoctorCategory();
  Future<List<dynamic>> addtofav(id);
  Future<CallMyDoctorResult> mydoctor();
  Future<List<dynamic>> removefav(id);
}
