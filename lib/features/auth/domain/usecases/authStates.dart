import '../entities/loginResponse.dart';

class LoginResult {
  final LoginResultStates state;
  final LoginResponse response;

  LoginResult(this.state, this.response);
}

enum LoginResultStates { isLoading, isError, isData, isIdle }

class RegisterResult {
  final RegisterResultStates state;
  final Map<String, dynamic> response;

  RegisterResult(this.state, this.response);
}

enum RegisterResultStates { isLoading, isError, isData, isIdle }

class ContinueRegisterResult {
  final ContinueRegisterResultStates state;
  final Map<String, dynamic> response;

  ContinueRegisterResult(this.state, this.response);
}

enum ContinueRegisterResultStates { isLoading, isError, isData, isIdle }

class SetUpHealthResult {
  final SetUpHealthResultStates state;
  final Map<String, dynamic> response;

  SetUpHealthResult(this.state, this.response);
}

enum SetUpHealthResultStates { isLoading, isError, isData, isIdle }

class VerifyEmailResult {
  final VerifyEmailResultStates state;
  final Map<String, dynamic> response;

  VerifyEmailResult(this.state, this.response);
}

enum VerifyEmailResultStates { isLoading, isError, isData, isIdle }

class GetInfoResult {
  final GetInfoResultStates state;
  final Map<String, dynamic> response;

  GetInfoResult(this.state, this.response);
}

enum GetInfoResultStates { isLoading, isError, isData, isIdle }
