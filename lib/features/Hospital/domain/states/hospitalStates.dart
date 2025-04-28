import '../entities/hospitalmodel.dart';

class HospitalResult {
  final HospitalResultStates state;
  final HospitalModel response;

  HospitalResult(this.state, this.response);
}

enum HospitalResultStates { isLoading, isError, isData, isIdle }
