import 'dart:developer';
import 'dart:io';

import 'package:h_smart/core/exceptions/network_exception.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';
import 'package:h_smart/features/auth/domain/entities/ContinueRegistrationModel.dart';

import '../../../../constant/enum.dart';
import '../entities/loginResponse.dart';
import '../usecases/authStates.dart';

abstract class AuthRepository {
  Future<RegisterResult> createacount(createaccount);
  Future<EmailVerificationResult> callActivationToken(email);
  Future<LoginResult> login(login);
  Future<VerifyEmailResult> Verifyemail(otp);
  Future<GetInfoResult> getinfo();
  Future<SetUpHealthResult> setuphealthissues(setup);
  Future<ContinueRegisterResult> continueRegistration(
      ContinueRegistrationModel continuemodel);
}

class AuthRepositoryImp implements AuthRepository {
  final AuthDatasource authDatasource;
  AuthRepositoryImp(this.authDatasource);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult =
        RegisterResult(RegisterResultStates.isLoading, {});

    try {
      registerResult = await authDatasource.createacount(createaccount);
    } catch (e) {
      log(e.toString());

      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        registerResult =
            RegisterResult(RegisterResultStates.isError, {"message": message});
      } else {
        registerResult = RegisterResult(
            RegisterResultStates.isError, {"message": "Something Went Wrong"});
      }
    }
    return registerResult;
  }

  @override
  Future<LoginResult> login(login) async {
    LoginResult loginResult =
        LoginResult(LoginResultStates.isLoading, LoginResponse());
    try {
      loginResult = await authDatasource.login(login);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        loginResult = LoginResult(
            LoginResultStates.isError, LoginResponse(message: message));
      } else {
        loginResult = LoginResult(LoginResultStates.isError,
            LoginResponse(message: "Something Went Wrong"));
      }
    }
    return loginResult;
  }

  @override
  Future<ContinueRegisterResult> continueRegistration(
      ContinueRegistrationModel continueModel) async {
    ContinueRegisterResult continueRegisterResult =
        ContinueRegisterResult(ContinueRegisterResultStates.isLoading, {});
    try {
      continueRegisterResult =
          await authDatasource.continueRegistration(continueModel);
    } catch (e) {
      log(e.toString());

      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        continueRegisterResult = ContinueRegisterResult(
            ContinueRegisterResultStates.isError, {"message": message});
      } else {
        continueRegisterResult = ContinueRegisterResult(
            ContinueRegisterResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return continueRegisterResult;
  }

  @override
  Future<VerifyEmailResult> Verifyemail(otp) async {
    VerifyEmailResult verifyEmailResult =
        VerifyEmailResult(VerifyEmailResultStates.isLoading, {});

    try {
      verifyEmailResult = await authDatasource.Verifyemail(otp);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        verifyEmailResult = VerifyEmailResult(
            VerifyEmailResultStates.isError, {"message": message});
      } else {
        verifyEmailResult = VerifyEmailResult(VerifyEmailResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return verifyEmailResult;
  }

  @override
  Future<SetUpHealthResult> setuphealthissues(setup) async {
    SetUpHealthResult setUpHealthResult =
        SetUpHealthResult(SetUpHealthResultStates.isLoading, {});

    try {
      setUpHealthResult = await authDatasource.setuphealthissues(setup);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        setUpHealthResult = SetUpHealthResult(
            SetUpHealthResultStates.isError, {"message": message});
      } else {
        setUpHealthResult = SetUpHealthResult(SetUpHealthResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return setUpHealthResult;
  }

  @override
  Future<GetInfoResult> getinfo() async {
    GetInfoResult getInfoResult =
        GetInfoResult(GetInfoResultStates.isLoading, {});
    try {
      getInfoResult = await authDatasource.getinfo();
    } catch (e) {
      log(e.toString());

      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        getInfoResult =
            GetInfoResult(GetInfoResultStates.isError, {"message": message});
      } else {
        getInfoResult = GetInfoResult(
            GetInfoResultStates.isError, {"message": "Something Went Wrong"});
      }
    }
    return getInfoResult;
  }

  @override
  Future<EmailVerificationResult> callActivationToken(email) async {
    EmailVerificationResult emailVerificationResult =
        EmailVerificationResult(EmailVerificationResultState.isLoading, {});
    try {
      emailVerificationResult = await authDatasource.callActivationToken(email);
    } catch (e) {
      log(e.toString());

      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        emailVerificationResult = EmailVerificationResult(
            EmailVerificationResultState.isError, {"message": message});
      } else {
        emailVerificationResult = EmailVerificationResult(
            EmailVerificationResultState.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return emailVerificationResult;
  }
}
