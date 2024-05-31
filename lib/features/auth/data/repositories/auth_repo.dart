import 'dart:io';

abstract class AuthDatasource {
  Future<List<String>> createacount(createaccount);
  Future<List<String>> login(login);
  Future<List<dynamic>> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl);
  Future<List<String>> Verifyemail(otp);
  Future<List<String>> setuphealthissues(setup);
    Future<List<dynamic>> getinfo();
}
