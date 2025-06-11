import '../../../medical_record/domain/entities/userDetailsModel.dart';
import '../entities/loginResponse.dart';

class LoginResult {
  final LoginResultStates state;
  final LoginResponse response;

  LoginResult(this.state, this.response);
}

enum LoginResultStates { isLoading, isError, isData, isIdle }

class SendTokenChangePasswordResult {
  final SendTokenChangePasswordResultStates state;
  final Map<String, dynamic> response;

  SendTokenChangePasswordResult(this.state, this.response);
}

enum SendTokenChangePasswordResultStates { isLoading, isError, isData, isIdle }

class ChangePasswordResult {
  final ChangePasswordResultStates state;
  final Map<String, dynamic> response;

  ChangePasswordResult(this.state, this.response);
}

enum ChangePasswordResultStates { isLoading, isError, isData, isIdle }

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

class GetUserResult {
  final GetUserResultStates state;
  final UserDetails response;

  GetUserResult(this.state, this.response);
}

enum GetUserResultStates { isLoading, isError, isData, isIdle, loggedOut }

class EmailVerificationResult {
  final EmailVerificationResultState state;
  final Map<String, dynamic> response;

  EmailVerificationResult(this.state, this.response);
}

enum EmailVerificationResultState { isLoading, isError, isData, isIdle }
