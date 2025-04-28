import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/enum.dart';
import '../../domain/entities/hospitalmodel.dart';
import '../../domain/states/hospitalStates.dart';

class HospitalDataSourceImp implements HospitalDataSource {
  final HttpService httpService;

  HospitalDataSourceImp(this.httpService);

  @override
  Future<HospitalResult> getHospital() async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, HospitalModel());
    final response = await httpService.request(
      url: '/Hospital-Operation/list/create/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedresponse = HospitalModel.fromJson(response.data);
      hospitalResult =
          HospitalResult(HospitalResultStates.isData, decodedresponse);
    }

    return hospitalResult;
  }
}
