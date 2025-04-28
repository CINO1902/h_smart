import 'dart:developer';

import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/hospitalmodel.dart';
import '../states/hospitalStates.dart';

abstract class HospitalRepo {
  Future<HospitalResult> getHospital();
}

class HospaitalRepoImp implements HospitalRepo {
  final HospitalDataSource hospitalDataSource;

  HospaitalRepoImp(this.hospitalDataSource);

  @override
  Future<HospitalResult> getHospital() async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, HospitalModel());

    try {
      hospitalResult = await hospitalDataSource.getHospital();
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        hospitalResult = HospitalResult(
            HospitalResultStates.isError, HospitalModel(msg: message));
      } else {
        hospitalResult = HospitalResult(HospitalResultStates.isError,
            HospitalModel(msg: "Something went wrong"));
      }
    }
    return hospitalResult;
  }
}
