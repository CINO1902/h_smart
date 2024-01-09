import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/enum.dart';

class HospitalDataSourceImp implements HospitalDataSource {
  final HttpService httpService;

  HospitalDataSourceImp(this.httpService);

  @override
  Future<List<List>> getHospital() async {
    String result = '';
    Map<String, dynamic> msg = {};

    List<List> returnvalue = [];

    final response = await httpService.request(
      url: '/Hospital-Operation/list/create/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      result = '1';
      msg = response.data;

      returnvalue.add([result]);
      returnvalue.add([msg]);
    }

    return returnvalue;
  }
}
