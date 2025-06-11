import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';

import '../entities/DoctorsResponse.dart';
import '../entities/GetHospital.dart';

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
