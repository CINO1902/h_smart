import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';

import '../../../../constant/enum.dart';
import '../../../../core/exceptions/network_exception.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/DoctorsResponse.dart';
import '../../domain/entities/DefaultHospitalResponse.dart';
import '../../domain/states/hospitalStates.dart';

class HospitalDataSourceImp implements HospitalDataSource {
  final HttpService httpService;

  HospitalDataSourceImp(this.httpService);

  @override
  Future<HospitalResult> getHospital() async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());
    final response = await httpService.request(
      url: '/auth/get_connected_hospitals',
      methodrequest: RequestMethod.getWithToken,
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

  @override
  Future<ConnectToHospitalResult> connectToHospital(hospitalId) async {
    ConnectToHospitalResult connectToHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isLoading, '');
    final response = await httpService.request(
        url: '/auth/register_to_hospital',
        methodrequest: RequestMethod.postWithToken,
        data: {"hospital_id": hospitalId});

    if (response.statusCode == 200) {
      connectToHospitalResult = ConnectToHospitalResult(
          ConnectToHospitalResultStates.isData, response.data['message']);
    }

    return connectToHospitalResult;
  }

  @override
  Future<DisconnectFromHospitalResult> disconnectFromHospital(
      hospitalId) async {
    DisconnectFromHospitalResult disconnectFromHospitalResult =
        DisconnectFromHospitalResult(
            DisconnectFromHospitalResultStates.isLoading, '');
    final response = await httpService.request(
        url: '/auth/register_to_hospital',
        methodrequest: RequestMethod.postWithToken,
        data: {"hospital_id": hospitalId});

    if (response.statusCode == 200 || response.statusCode == 201) {
      disconnectFromHospitalResult = DisconnectFromHospitalResult(
          DisconnectFromHospitalResultStates.isData, response.data['message']);
    }

    return disconnectFromHospitalResult;
  }

  @override
  Future<DefaultHospitalResult> getDefaultHospital() async {
    DefaultHospitalResult defaultHospitalResult = DefaultHospitalResult(
        DefaultHospitalResultStates.isLoading,
        DefaultHospitalResponse(error: true, message: ''));

    final response = await httpService.request(
      url: '/auth/default_hospital',
      methodrequest: RequestMethod.getWithToken,
    );

    if (response.statusCode == 200) {
      final defaultHospitalResponse =
          DefaultHospitalResponse.fromJson(response.data);
      defaultHospitalResult = DefaultHospitalResult(
          DefaultHospitalResultStates.isData, defaultHospitalResponse);
    }

    return defaultHospitalResult;
  }

  @override
  Future<ConnectToHospitalResult> setDefaultHospital(String hospitalId) async {
    ConnectToHospitalResult setDefaultHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isLoading, '');
    final response = await httpService.request(
      url: '/auth/set_default_hospital/$hospitalId',
      methodrequest: RequestMethod.putWithToken,
    );

    if (response.statusCode == 200) {
      setDefaultHospitalResult = ConnectToHospitalResult(
          ConnectToHospitalResultStates.isData, response.data['message']);
    }

    return setDefaultHospitalResult;
  }
}
