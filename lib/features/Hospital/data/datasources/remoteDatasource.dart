import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';

import '../../../../constant/enum.dart';
import '../../domain/entities/DoctorsResponse.dart';
import '../../domain/states/hospitalStates.dart';

class HospitalDataSourceImp implements HospitalDataSource {
  final HttpService httpService;

  HospitalDataSourceImp(this.httpService);

  @override
  Future<HospitalResult> getHospital() async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    final response = await httpService.request(
      url: '/hospitals/search',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedresponse = GetHospital.fromJson(response.data);
      hospitalResult =
          HospitalResult(HospitalResultStates.isData, decodedresponse);
    }

    return hospitalResult;
  }

  @override
  Future<HospitalResult> getMoreSpecificHospital(ownnershiptype, page) async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    final response = await httpService.request(
      url:
          '/hospitals/search?ownership_type=$ownnershiptype&page=1&per_page=10',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedresponse = GetHospital.fromJson(response.data);
      hospitalResult =
          HospitalResult(HospitalResultStates.isData, decodedresponse);
    }

    return hospitalResult;
  }

  @override
  Future<HospitalResult> searchHospital(search) async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    final response = await httpService.request(
      url: '/hospitals/search?search=$search&page=1&per_page=10',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedresponse = GetHospital.fromJson(response.data);
      hospitalResult =
          HospitalResult(HospitalResultStates.isData, decodedresponse);
    }

    return hospitalResult;
  }

  @override
  Future<DoctorResult> GetDoctorsByHospitalId(hospitalId) async {
    DoctorResult doctorResult = DoctorResult(DoctorResultStates.isLoading,
        DoctorsResponse(doctors: [], message: ''));
    final response = await httpService.request(
      url: '/doctors/$hospitalId',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedresponse = DoctorsResponse.fromJson(response.data);
      doctorResult = DoctorResult(DoctorResultStates.isData, decodedresponse);
    }

    return doctorResult;
  }
}
