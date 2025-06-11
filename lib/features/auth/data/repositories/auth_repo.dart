import '../../domain/entities/ContinueRegistrationModel.dart';
import '../../domain/usecases/authStates.dart';

abstract class AuthDatasource {
  Future<RegisterResult> createacount(createaccount);
  Future<LoginResult> login(login);
  Future<VerifyEmailResult> Verifyemail(otp);
  Future<ChangePasswordResult> changepassword(token, password);
  Future<SendTokenChangePasswordResult> sendtokenChangePassword(email);
  Future<GetUserResult> getuserdetails();
  Future<SetUpHealthResult> setuphealthissues(setup);
  Future<ContinueRegisterResult> continueRegistration(
      ContinueRegistrationModel continuemodel);
  Future<EmailVerificationResult> callActivationToken(email);
}
