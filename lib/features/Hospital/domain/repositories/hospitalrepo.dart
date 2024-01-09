import 'dart:developer';

import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';

import '../../../../core/exceptions/network_exception.dart';

abstract class HospitalRepo {
  Future<List<List>> getHospital();
}

class HospaitalRepoImp implements HospitalRepo {
  final HospitalDataSource hospitalDataSource;

  HospaitalRepoImp(this.hospitalDataSource);

  @override
  Future<List<List>> getHospital() async {
    List<List> returnresponse = [];

    try {
      returnresponse = await hospitalDataSource.getHospital();
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;

      returnresponse.add(['2']);
      returnresponse.add([exp.errorMessage!]);
    }
    return returnresponse;
  }
}
