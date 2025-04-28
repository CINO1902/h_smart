import '../entities/SpecialisedDoctor.dart';
import '../entities/mydoctor.dart';

class CallMyDoctorResult {
  final CallMyDoctorResultState state;
  final Mydoctor response;

  CallMyDoctorResult(this.state, this.response);
}

enum CallMyDoctorResultState { isLoading, isError, isData, idle }

class GetDoctorListResult {
  final GetDoctorListResultStates state;
  final SpecializeDoctor response;

  GetDoctorListResult(this.state, this.response);
}

enum GetDoctorListResultStates { isLoading, isError, isData, idle }

// class CallMyDoctorResult {
//   final CallMyDoctorResultState state;
//   final Mydoctor response;

//   CallMyDoctorResult(this.state, this.response);
// }

// enum CallMyDoctorResultState { isLoading, isError, isData, idle }
