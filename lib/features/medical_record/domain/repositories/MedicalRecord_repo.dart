import 'dart:developer';

import 'package:h_smart/core/exceptions/network_exception.dart';
import 'package:h_smart/features/medical_record/data/repositories/medicalRecordRepo.dart';
import 'package:h_smart/features/medical_record/domain/usecases/userStates.dart';

import '../../../../constant/enum.dart';
import '../entities/GetOverView.dart';

abstract class MedicalRecordRepo {
  Future<List<dynamic>> getprescription();
  Future<GetOverResult> getOverview();
}

class MedicalRecordRepoImp implements MedicalRecordRepo {
  final MedicalRecordDatasource medicalRecordDatasource;

  MedicalRecordRepoImp(this.medicalRecordDatasource);
  @override
  Future<List> getprescription() async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await medicalRecordDatasource.getprescription();
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);
      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<GetOverResult> getOverview() async {
    GetOverResult returnresponse =
        GetOverResult(status: GetOverResultStates.fail, data: GetOverView());
    try {
      returnresponse = await medicalRecordDatasource.getOverview();
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        returnresponse = GetOverResult(
            status: GetOverResultStates.fail,
            data: GetOverView(message: exp.message));
      } else {
        returnresponse = GetOverResult(
            status: GetOverResultStates.fail,
            data: GetOverView(message: "Something went wrong"));
      }
    }
    return returnresponse;
  }
}
