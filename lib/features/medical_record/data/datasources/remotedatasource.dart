import 'package:h_smart/constant/enum.dart';
import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/medical_record/data/repositories/medicalRecordRepo.dart';
import 'package:h_smart/features/medical_record/domain/usecases/userStates.dart';

import '../../domain/entities/GetOverView.dart';
import '../../domain/entities/prescription.dart';

class MedicalRecordDataSourceImp implements MedicalRecordDatasource {
  final HttpService httpService;

  MedicalRecordDataSourceImp(this.httpService);
  @override
  Future<GetPrescriptionResult> getprescription() async {
    GetPrescriptionResult returnresponse = GetPrescriptionResult(
         GetPrescriptionResultStates.fail,  PescriptionResponse());

    final response = await httpService.request(
      url: '/doctors/prescriptions',
      methodrequest: RequestMethod.getWithToken,
    );

    if (response.statusCode == 200) {
      PescriptionResponse data = PescriptionResponse.fromJson(response.data);
      returnresponse = GetPrescriptionResult(
           GetPrescriptionResultStates.success,  data);
    }

    return returnresponse;
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
