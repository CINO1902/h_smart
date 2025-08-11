import 'dart:convert';

import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';
import 'package:h_smart/features/auth/domain/entities/ContinueRegistrationModel.dart';
import 'package:h_smart/features/auth/domain/entities/loginResponse.dart';
import 'package:h_smart/features/auth/domain/entities/loginmodel.dart';
import 'package:h_smart/features/auth/domain/entities/setuphealthissue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/enum.dart';
import '../../../medical_record/domain/entities/userDetailsModel.dart';
import '../../domain/entities/createaccount.dart';
import '../../domain/usecases/authStates.dart';

class AuthDatasourceImp implements AuthDatasource {
  final HttpService httpService;

  AuthDatasourceImp(this.httpService);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult =
        RegisterResult(RegisterResultStates.isLoading, {});
    final response = await httpService.request(
        url: '/auth/register',
        methodrequest: RequestMethod.post,
        data: registermodelToJson(createaccount));

    if (response.statusCode == 201) {
      // token = response.data['access_token'];
      registerResult =
          RegisterResult(RegisterResultStates.isData, response.data);
    }

    return registerResult;
  }

  @override
  Future<LoginResult> login(login) async {
    LoginResult loginResult =
        LoginResult(LoginResultStates.isLoading, LoginResponse());

    final response = await httpService.request(
        url: '/auth/login',
        methodrequest: RequestMethod.post,
        data: loginModelToJson(login));

    if (response.statusCode == 200) {
      final decodedresponse = LoginResponse.fromJson(response.data);
      loginResult = LoginResult(LoginResultStates.isData, decodedresponse);
    }

    return loginResult;
  }

  @override
  Future<ContinueRegisterResult> continueRegistration(
      ContinueRegistrationModel continueModel) async {
    // print(continueModel.toJson());
    ContinueRegisterResult continueRegisterResult =
        ContinueRegisterResult(ContinueRegisterResultStates.isLoading, {});
    print(continueModel.toJson());
    final response = await httpService.request(
        url: '/auth/create_patient_profile_metadata',
        methodrequest: RequestMethod.postWithToken,
        data: continueRegistrationModelToJson(continueModel));

    if (response.statusCode == 201) {
      print(response.data['payload']);
      continueRegisterResult = ContinueRegisterResult(
          ContinueRegisterResultStates.isData,
          {"message": response.data['message']});
    }

    return continueRegisterResult;
  }

  @override
  Future<VerifyEmailResult> Verifyemail(otp) async {
    VerifyEmailResult verifyEmailResult =
        VerifyEmailResult(VerifyEmailResultStates.isLoading, {});

    final response = await httpService.request(
        url: '/auth/activate',
        methodrequest: RequestMethod.post,
        data: {
          "token": otp,
        });

    if (response.statusCode == 200) {
      verifyEmailResult = VerifyEmailResult(VerifyEmailResultStates.isData, {
        "message": response.data['message'],
        "payload": response.data['payload']
      });
    }

    return verifyEmailResult;
  }

  @override
  Future<SetUpHealthResult> setuphealthissues(setup) async {
    SetUpHealthResult setUpHealthResult =
        SetUpHealthResult(SetUpHealthResultStates.isLoading, {});

    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
      'content-Type': 'application/json',
    };
    final response = await httpService.request(
        url: '/User-Health-Info/',
        methodrequest: RequestMethod.post,
        data: setUpHealthIssueToJson(setup));

    if (response.statusCode == 201) {
      setUpHealthResult =
          SetUpHealthResult(SetUpHealthResultStates.isData, response.data);
    }

    return setUpHealthResult;
  }

  @override
  Future<GetUserResult> getuserdetails() async {
    GetUserResult changePasswordResult =
        GetUserResult(GetUserResultStates.isLoading, UserDetails());

    final response = await httpService.request(
      url: '/auth/profile',
      methodrequest: RequestMethod.getWithToken,
    );

    if (response.statusCode == 200) {
      final decodedresponse = UserDetails.fromJson(response.data);
      changePasswordResult =
          GetUserResult(GetUserResultStates.isData, decodedresponse);
    }

    return changePasswordResult;
  }

  @override
  Future<EmailVerificationResult> callActivationToken(email) async {
    EmailVerificationResult emailVerificationResult =
        EmailVerificationResult(EmailVerificationResultState.isLoading, {});

    final response = await httpService.request(
        url: '/auth/activate_token',
        methodrequest: RequestMethod.post,
        data: jsonEncode({"email": email}));

    if (response.statusCode == 200) {
      emailVerificationResult = EmailVerificationResult(
          EmailVerificationResultState.isData, response.data);
    }

    return emailVerificationResult;
  }

  @override
  Future<SendTokenChangePasswordResult> sendtokenChangePassword(email) async {
    SendTokenChangePasswordResult sendTokenChangePasswordResult =
        SendTokenChangePasswordResult(
            SendTokenChangePasswordResultStates.isLoading, {});

    final response = await httpService.request(
        url: '/auth/activate_token',
        methodrequest: RequestMethod.post,
        data: jsonEncode({"email": email}));

    if (response.statusCode == 200) {
      sendTokenChangePasswordResult = SendTokenChangePasswordResult(
          SendTokenChangePasswordResultStates.isData, response.data);
    }

    return sendTokenChangePasswordResult;
  }

  @override
  Future<ChangePasswordResult> changepassword(token, password) async {
    ChangePasswordResult changePasswordResult =
        ChangePasswordResult(ChangePasswordResultStates.isLoading, {});

    final response = await httpService.request(
        url: '/auth/change_password',
        methodrequest: RequestMethod.post,
        data: jsonEncode({"token": token, "password": password}));

    if (response.statusCode == 200) {
      changePasswordResult = ChangePasswordResult(
          ChangePasswordResultStates.isData, response.data);
    }

    return changePasswordResult;
  }

  @override
  Future<LoginResult> ReactivateAccessToken(String token) async {
    LoginResult loginResult =
        LoginResult(LoginResultStates.isLoading, LoginResponse());

    final response = await httpService.request(
        url: '/auth/refresh',
        methodrequest: RequestMethod.post,
        data: {"refresh_token": token});

    if (response.statusCode == 200) {
      final decodedresponse = LoginResponse.fromJson(response.data);
      loginResult = LoginResult(LoginResultStates.isData, decodedresponse);
    }

    return loginResult;
  }
}
