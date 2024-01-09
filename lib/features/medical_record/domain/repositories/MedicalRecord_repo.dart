import 'dart:developer';

import 'package:h_smart/core/exceptions/network_exception.dart';
import 'package:h_smart/features/medical_record/data/repositories/medicalRecordRepo.dart';

abstract class MedicalRecordRepo {
  Future<List<dynamic>> getprescription();
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
}
