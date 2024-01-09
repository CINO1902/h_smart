import 'package:h_smart/constant/enum.dart';
import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/medical_record/data/repositories/medicalRecordRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordDataSourceImp implements MedicalRecordDatasource {
  final HttpService httpService;

  MedicalRecordDataSourceImp(this.httpService);
  @override
  Future<List> getprescription() async {
    String result = '';
    Map<String, dynamic> data = {};

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
      'content-Type': 'application/json',
    };
    final response = await httpService.request(
      url: '/get_prescription',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      result = '2';
      data = response.data;
      returnvalue.add(result);
      returnvalue.add(data);
    }

    return returnvalue;
  }
}
