import 'dart:developer';

import 'package:h_smart/constant/enum.dart';
import 'package:h_smart/features/Hospital/data/repositories/hospital_repo.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';

import '../../../../core/exceptions/network_exception.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/DoctorsResponse.dart';
import '../entities/DefaultHospitalResponse.dart';
import '../states/hospitalStates.dart';

abstract class HospitalRepo {
  Future<HospitalResult> getHospital();
  Future<HospitalResult> getMoreSpecificHospital(ownnershiptype, page);
  Future<HospitalResult> searchHospital(search);
  Future<DoctorResult> GetDoctorsByHospitalId(hospitalId);
  Future<ConnectToHospitalResult> connectToHospital(hospitalId);
  Future<DisconnectFromHospitalResult> disconnectFromHospital(hospitalId);
  Future<DefaultHospitalResult> getDefaultHospital();
  Future<ConnectToHospitalResult> setDefaultHospital(String hospitalId);
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

  @override
  Future<ConnectToHospitalResult> connectToHospital(hospitalId) async {
    ConnectToHospitalResult connectToHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isLoading, '');
    try {
      connectToHospitalResult =
          await hospitalDataSource.connectToHospital(hospitalId);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? '';
        if (exp.type == NetworkExceptionType.notFound) {
          connectToHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.notFound, message);
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          connectToHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.noNetWork, message);
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          connectToHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.isTimedOut, message);
        } else {
          connectToHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.isError, message);
        }
      } else {
        connectToHospitalResult = ConnectToHospitalResult(
            ConnectToHospitalResultStates.isError, 'Something went wrong');
      }
    }

    return connectToHospitalResult;
  }

  @override
  Future<DisconnectFromHospitalResult> disconnectFromHospital(hospitalId) async {
    DisconnectFromHospitalResult disconnectFromHospitalResult =
        DisconnectFromHospitalResult(DisconnectFromHospitalResultStates.isLoading, '');
    try {
      disconnectFromHospitalResult =
          await hospitalDataSource.disconnectFromHospital(hospitalId);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? '';
        if (exp.type == NetworkExceptionType.notFound) {
          disconnectFromHospitalResult = DisconnectFromHospitalResult(
              DisconnectFromHospitalResultStates.notFound, message);
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          disconnectFromHospitalResult = DisconnectFromHospitalResult(
              DisconnectFromHospitalResultStates.noNetWork, message);
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          disconnectFromHospitalResult = DisconnectFromHospitalResult(
              DisconnectFromHospitalResultStates.isTimedOut, message);
        } else {
          disconnectFromHospitalResult = DisconnectFromHospitalResult(
              DisconnectFromHospitalResultStates.isError, message);
        }
      } else {
        disconnectFromHospitalResult = DisconnectFromHospitalResult(
            DisconnectFromHospitalResultStates.isError, 'Something went wrong');
      }
    }

    return disconnectFromHospitalResult;
  }

  @override
  Future<DefaultHospitalResult> getDefaultHospital() async {
    DefaultHospitalResult defaultHospitalResult = DefaultHospitalResult(
        DefaultHospitalResultStates.isLoading, 
        DefaultHospitalResponse(error: true, message: ''));
    try {
      defaultHospitalResult = await hospitalDataSource.getDefaultHospital();
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? '';
        if (exp.type == NetworkExceptionType.notFound) {
          defaultHospitalResult = DefaultHospitalResult(
              DefaultHospitalResultStates.isEmpty, 
              DefaultHospitalResponse(error: true, message: message));
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          defaultHospitalResult = DefaultHospitalResult(
              DefaultHospitalResultStates.noNetWork, 
              DefaultHospitalResponse(error: true, message: message));
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          defaultHospitalResult = DefaultHospitalResult(
              DefaultHospitalResultStates.isTimedOut, 
              DefaultHospitalResponse(error: true, message: message));
        } else {
          defaultHospitalResult = DefaultHospitalResult(
              DefaultHospitalResultStates.isError, 
              DefaultHospitalResponse(error: true, message: message));
        }
      } else {
        defaultHospitalResult = DefaultHospitalResult(
            DefaultHospitalResultStates.isError, 
            DefaultHospitalResponse(error: true, message: 'Something went wrong'));
      }
    }

    return defaultHospitalResult;
  }

  @override
  Future<ConnectToHospitalResult> setDefaultHospital(String hospitalId) async {
    ConnectToHospitalResult setDefaultHospitalResult =
        ConnectToHospitalResult(ConnectToHospitalResultStates.isLoading, '');
    try {
      setDefaultHospitalResult =
          await hospitalDataSource.setDefaultHospital(hospitalId);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? '';
        if (exp.type == NetworkExceptionType.notFound) {
          setDefaultHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.notFound, message);
        } else if (exp.type == NetworkExceptionType.noInternetConnection) {
          setDefaultHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.noNetWork, message);
        } else if (exp.type == NetworkExceptionType.requestTimeOut ||
            exp.type == NetworkExceptionType.sendTimeOut) {
          setDefaultHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.isTimedOut, message);
        } else {
          setDefaultHospitalResult = ConnectToHospitalResult(
              ConnectToHospitalResultStates.isError, message);
        }
      } else {
        setDefaultHospitalResult = ConnectToHospitalResult(
            ConnectToHospitalResultStates.isError, 'Something went wrong');
      }
    }

    return setDefaultHospitalResult;
  }
}
