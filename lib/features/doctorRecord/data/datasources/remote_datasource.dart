
import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/mydoctor.dart';
import '../../domain/usecases/doctorStates.dart';

class DoctorDatasourceImp implements DoctorDatasource {
  final HttpService httpService;
  DoctorDatasourceImp(this.httpService);


  @override
  Future<List> getDoctorCategory() async {
    String result = '';

    List<dynamic> returnvalue = [];

    final response = await httpService.request(
      url: '/Specialization-Operation/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }

  @override
  Future<List> addtofav(id) async {
    String result = '';

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
        url: '/my-doctor/',
        methodrequest: RequestMethod.post,
        data: {'doctor': id});

    if (response.statusCode == 201) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }

  @override
  Future<CallMyDoctorResult> mydoctor() async {
    CallMyDoctorResult callMyDoctorResult =
        CallMyDoctorResult(CallMyDoctorResultState.isLoading, Mydoctor());
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
      url: '/my/doctor/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      // result = '2';

      // returnvalue.add(result);
      // returnvalue.add(response.data);
      final decodedresponse = mydoctorFromJson(response.data);
      callMyDoctorResult =
          CallMyDoctorResult(CallMyDoctorResultState.isData, decodedresponse);
    }

    return callMyDoctorResult;
  }

  @override
  Future<List> removefav(id) async {
    String result = '';

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
      url: '/my/doctor/$id/',
      methodrequest: RequestMethod.delete,
    );

    if (response.statusCode == 204) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }
}
