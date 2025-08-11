import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';

import 'package:h_smart/features/doctorRecord/domain/entities/DoctorsResponse.dart';
import '../entities/GetHospital.dart';
import '../entities/DefaultHospitalResponse.dart';

class HospitalResult {
  final HospitalResultStates state;
  final GetHospital response;

  HospitalResult(this.state, this.response);
}

enum HospitalResultStates {
  isLoading,
  isError,
  isEmpty,
  isTimedOut,
  noNetWork,
  isData,
  isIdle
}

class DoctorResult {
  final DoctorResultStates state;
  final DoctorsResponse response;

  DoctorResult(this.state, this.response);

  bool get isLoading => state == DoctorResultStates.isLoading;
  bool get isError => state == DoctorResultStates.isError;
  bool get isEmpty => state == DoctorResultStates.isEmpty;
  bool get isTimedout => state == DoctorResultStates.isTimedOut;
  bool get noNetwork => state == DoctorResultStates.noNetWork;
  bool get isData => state == DoctorResultStates.isData;
  bool get isIdle => state == DoctorResultStates.isIdle;
}

enum DoctorResultStates {
  isLoading,
  isError,
  isEmpty,
  isTimedOut,
  noNetWork,
  isData,
  isIdle
}

class ConnectToHospitalResult {
  final ConnectToHospitalResultStates state;
  final String message;

  ConnectToHospitalResult(this.state, this.message);
}

enum ConnectToHospitalResultStates {
  isLoading,
  isError,
  isData,
  notFound,
  isTimedOut,
  noNetWork,
  isIdle
}

class DisconnectFromHospitalResult {
  final DisconnectFromHospitalResultStates state;
  final String message;

  DisconnectFromHospitalResult(this.state, this.message);
}

enum DisconnectFromHospitalResultStates {
  isLoading,
  isError,
  isData,
  notFound,
  isTimedOut,
  noNetWork,
  isIdle
}

class DefaultHospitalResult {
  final DefaultHospitalResultStates state;
  final DefaultHospitalResponse response;

  DefaultHospitalResult(this.state, this.response);

  bool get isLoading => state == DefaultHospitalResultStates.isLoading;
  bool get isError => state == DefaultHospitalResultStates.isError;
  bool get isEmpty => state == DefaultHospitalResultStates.isEmpty;
  bool get isTimedout => state == DefaultHospitalResultStates.isTimedOut;
  bool get noNetwork => state == DefaultHospitalResultStates.noNetWork;
  bool get isData => state == DefaultHospitalResultStates.isData;
  bool get isIdle => state == DefaultHospitalResultStates.isIdle;
}

enum DefaultHospitalResultStates {
  isLoading,
  isError,
  isEmpty,
  isTimedOut,
  noNetWork,
  isData,
  isIdle
}
