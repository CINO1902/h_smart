import 'dart:developer';
import 'dart:io';

import 'package:h_smart/core/exceptions/network_exception.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';

import '../../../../constant/enum.dart';
import '../entities/loginResponse.dart';
import '../usecases/authStates.dart';

abstract class AuthRepository {
  Future<RegisterResult> createacount(createaccount);
  Future<LoginResult> login(login);
  Future<VerifyEmailResult> Verifyemail(otp);
  Future<GetInfoResult> getinfo();
  Future<SetUpHealthResult> setuphealthissues(setup);
  Future<ContinueRegisterResult> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl);
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
        loginResult = LoginResult(
            LoginResultStates.isError,LoginResponse(message: "Something Went Wrong"));
      }
    }

    return loginResult;
  }

  @override
  Future<ContinueRegisterResult> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl) async {
    ContinueRegisterResult continueRegisterResult =
        ContinueRegisterResult(ContinueRegisterResultStates.isLoading, {});
    try {
      continueRegisterResult = await authDatasource.continueRegistration(
          firstname, lastname, phone, dob, address, image, imageurl);
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
}
