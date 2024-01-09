abstract class DoctorDatasource {
  Future<List<dynamic>> getDoctorList();
  Future<List<dynamic>> getDoctorCategory();
  Future<List<dynamic>> addtofav(id);
  Future<List<dynamic>> mydoctor();
  Future<List<dynamic>> removefav(id);
}
