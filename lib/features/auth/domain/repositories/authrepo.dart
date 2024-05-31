import 'dart:developer';
import 'dart:io';

import 'package:h_smart/core/exceptions/network_exception.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';

abstract class AuthRepository {
  Future<List<String>> createacount(createaccount);
  Future<List<String>> login(login);
  Future<List<String>> Verifyemail(otp);
  Future<List<dynamic>> getinfo();
  Future<List<String>> setuphealthissues(setup);
  Future<List<dynamic>> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl);
}

class AuthRepositoryImp implements AuthRepository {
  final AuthDatasource authDatasource;
  AuthRepositoryImp(this.authDatasource);
  @override
  Future<List<String>> createacount(createaccount) async {
    List<String> returnresponse = [];

    try {
      returnresponse = await authDatasource.createacount(createaccount);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;

      returnresponse.add('2');
      returnresponse.add(exp.errorMessage!);
    }
    return returnresponse;
  }

  @override
  Future<List<String>> login(login) async {
    List<String> returnresponse = [];

    try {
      returnresponse = await authDatasource.login(login);
    } catch (e) {
      NetworkException exp = e as NetworkException;
      print(e);

      returnresponse.add('1');
      returnresponse.add(exp.message);
      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List<dynamic>> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl) async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await authDatasource.continueRegistration(
          firstname, lastname, phone, dob, address, image, imageurl);
    } catch (e) {
      NetworkException exp = e as NetworkException;
      print(e);

      returnresponse.add('2');
      returnresponse.add(exp.message);
      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List<String>> Verifyemail(otp) async {
    List<String> returnresponse = [];

    try {
      returnresponse = await authDatasource.Verifyemail(otp);
    } catch (e) {
      NetworkException exp = e as NetworkException;
      print(e);

      returnresponse.add('1');
      returnresponse.add(exp.message);
      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List<String>> setuphealthissues(setup) async {
    List<String> returnresponse = [];

    try {
      returnresponse = await authDatasource.setuphealthissues(setup);
    } catch (e) {
      NetworkException exp = e as NetworkException;
      print(e);

      returnresponse.add('1');
      returnresponse.add(exp.message);
      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List<dynamic>> getinfo() async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await authDatasource.getinfo();
    } catch (e) {
      NetworkException exp = e as NetworkException;
      print(e);

      returnresponse.add('1');
      returnresponse.add(exp.message);
      log(e.toString());
    }
    return returnresponse;
  }
}
