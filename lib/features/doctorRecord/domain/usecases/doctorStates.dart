import '../entities/mydoctor.dart';

class CallMyDoctorResult {
  final CallMyDoctorResultState state;
  final Mydoctor response;

  CallMyDoctorResult(this.state, this.response);
}

enum CallMyDoctorResultState { isLoading, isError, isData, idle }

// class CallMyDoctorResult {
//   final CallMyDoctorResultState state;
//   final Mydoctor response;

//   CallMyDoctorResult(this.state, this.response);
// }

// enum CallMyDoctorResultState { isLoading, isError, isData, idle }
