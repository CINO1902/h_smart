import 'dart:developer';

import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/mydoctor.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/SpecialisedDoctor.dart';
import '../usecases/doctorStates.dart';

abstract class DoctorRepository {
  Future<GetDoctorListResult> getDoctorList();
  Future<List<dynamic>> getDoctorCategory();
  Future<List<dynamic>> addtofav(id);
  Future<CallMyDoctorResult> mydoctor();
  Future<List<dynamic>> removefav(id);
}

class DoctorRepoImpl implements DoctorRepository {
  final DoctorDatasource doctorDatasource;

  DoctorRepoImpl(this.doctorDatasource);

  @override
  Future<GetDoctorListResult> getDoctorList() async {
    GetDoctorListResult getDoctorListResult = GetDoctorListResult(
        GetDoctorListResultStates.isLoading, SpecializeDoctor());

    try {
      getDoctorListResult = await doctorDatasource.getDoctorList();
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        getDoctorListResult = GetDoctorListResult(
            GetDoctorListResultStates.isError,
            SpecializeDoctor(message: exp.errorMessage));
      } else {
        getDoctorListResult = GetDoctorListResult(
            GetDoctorListResultStates.isError,
            SpecializeDoctor(message: "Something went wrong"));
      }
    }
    return getDoctorListResult;
  }

  @override
  Future<List> getDoctorCategory() async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.getDoctorCategory();
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List> addtofav(id) async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.addtofav(id);
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<CallMyDoctorResult> mydoctor() async {
    CallMyDoctorResult callMyDoctorResult =
        CallMyDoctorResult(CallMyDoctorResultState.isLoading, Mydoctor());

    try {
      callMyDoctorResult = await doctorDatasource.mydoctor();
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;

        // returnresponse.add('1');
        // returnresponse.add(exp.message);
        callMyDoctorResult = CallMyDoctorResult(CallMyDoctorResultState.isError,
            Mydoctor(message: exp.errorMessage));
      } else {
        callMyDoctorResult = CallMyDoctorResult(CallMyDoctorResultState.isError,
            Mydoctor(message: "Something went wrong"));
      }

      log(e.toString());
    }
    return callMyDoctorResult;
  }

  @override
  Future<List> removefav(id) async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.removefav(id);
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }
}
