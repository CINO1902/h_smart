import 'dart:io';

import '../../domain/usecases/authStates.dart';

abstract class AuthDatasource {
  Future<RegisterResult> createacount(createaccount);
  Future<LoginResult> login(login);
  Future<VerifyEmailResult> Verifyemail(otp);
  Future<GetInfoResult> getinfo();
  Future<SetUpHealthResult> setuphealthissues(setup);
  Future<ContinueRegisterResult> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl);
}
