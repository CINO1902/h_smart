import 'package:h_smart/constant/enum.dart';
import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/medical_record/data/repositories/medicalRecordRepo.dart';
import 'package:h_smart/features/medical_record/domain/usecases/userStates.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/GetOverView.dart';

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

  @override
  Future<GetOverResult> getOverview() async {
    GetOverResult returnresponse =
        GetOverResult(status: GetOverResultStates.fail, data: GetOverView());
    final respone = await httpService.request(
        url: '/auth/overview', methodrequest: RequestMethod.getWithToken);
    if (respone.statusCode == 200) {
      GetOverView getOverView = GetOverView.fromJson(respone.data);
      returnresponse =
          GetOverResult(status: GetOverResultStates.success, data: getOverView);
    }
    return returnresponse;
  }
}
