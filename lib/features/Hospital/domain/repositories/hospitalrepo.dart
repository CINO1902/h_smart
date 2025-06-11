import 'dart:developer';

import 'package:h_smart/constant/enum.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/DoctorsResponse.dart';
import '../states/hospitalStates.dart';

abstract class HospitalRepo {
  Future<HospitalResult> getHospital();
  Future<HospitalResult> getMoreSpecificHospital(ownnershiptype, page);
  Future<HospitalResult> searchHospital(search);
  Future<DoctorResult> GetDoctorsByHospitalId(hospitalId);
}

class HospaitalRepoImp implements HospitalRepo {
  final HospitalDataSource hospitalDataSource;

  HospaitalRepoImp(this.hospitalDataSource);

  @override
  Future<HospitalResult> getHospital() async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());

    try {
      hospitalResult = await hospitalDataSource.getHospital();
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        if (exp.type == NetworkExceptionType.notFound) {
          hospitalResult =
              HospitalResult(HospitalResultStates.isEmpty, GetHospital());
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          hospitalResult =
              HospitalResult(HospitalResultStates.noNetWork, GetHospital());
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          hospitalResult =
              HospitalResult(HospitalResultStates.isTimedOut, GetHospital());
        } else {
          hospitalResult =
              HospitalResult(HospitalResultStates.isError, GetHospital());
        }
      } else {
        hospitalResult =
            HospitalResult(HospitalResultStates.isError, GetHospital());
      }
    }
    return hospitalResult;
  }

  @override
  Future<HospitalResult> getMoreSpecificHospital(ownnershiptype, page) async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());

    try {
      hospitalResult = await hospitalDataSource.getMoreSpecificHospital(
          ownnershiptype, page);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        if (exp.type == NetworkExceptionType.notFound) {
          hospitalResult =
              HospitalResult(HospitalResultStates.isEmpty, GetHospital());
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          hospitalResult =
              HospitalResult(HospitalResultStates.noNetWork, GetHospital());
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          hospitalResult =
              HospitalResult(HospitalResultStates.isTimedOut, GetHospital());
        } else {
          hospitalResult =
              HospitalResult(HospitalResultStates.isError, GetHospital());
        }
      } else {
        hospitalResult =
            HospitalResult(HospitalResultStates.isError, GetHospital());
      }
    }
    return hospitalResult;
  }

  @override
  Future<HospitalResult> searchHospital(search) async {
    HospitalResult hospitalResult =
        HospitalResult(HospitalResultStates.isLoading, GetHospital());

    try {
      hospitalResult = await hospitalDataSource.searchHospital(search);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        if (exp.type == NetworkExceptionType.notFound) {
          hospitalResult =
              HospitalResult(HospitalResultStates.isEmpty, GetHospital());
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          hospitalResult =
              HospitalResult(HospitalResultStates.noNetWork, GetHospital());
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          hospitalResult =
              HospitalResult(HospitalResultStates.isTimedOut, GetHospital());
        } else {
          hospitalResult =
              HospitalResult(HospitalResultStates.isError, GetHospital());
        }
      } else {
        hospitalResult =
            HospitalResult(HospitalResultStates.isError, GetHospital());
      }
    }
    return hospitalResult;
  }

  @override
  Future<DoctorResult> GetDoctorsByHospitalId(hospitalId) async {
    DoctorResult doctorResult = DoctorResult(DoctorResultStates.isLoading,
        DoctorsResponse(doctors: [], message: ''));

    try {
      doctorResult =
          await hospitalDataSource.GetDoctorsByHospitalId(hospitalId);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? '';
        if (exp.type == NetworkExceptionType.notFound) {
          doctorResult = DoctorResult(DoctorResultStates.isEmpty,
              DoctorsResponse(doctors: [], message: message));
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          doctorResult = DoctorResult(DoctorResultStates.noNetWork,
              DoctorsResponse(doctors: [], message: message));
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          doctorResult = DoctorResult(DoctorResultStates.isTimedOut,
              DoctorsResponse(doctors: [], message: message));
        } else {
          doctorResult = DoctorResult(DoctorResultStates.isError,
              DoctorsResponse(doctors: [], message: message));
        }
      } else {
        doctorResult = DoctorResult(DoctorResultStates.isError,
            DoctorsResponse(doctors: [], message: 'Something went wrong'));
      }
    }
    return doctorResult;
  }
}
