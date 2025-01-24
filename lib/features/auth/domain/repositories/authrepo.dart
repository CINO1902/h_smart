import 'dart:developer';
import 'dart:io';

import 'package:h_smart/core/exceptions/network_exception.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';

import '../../../../constant/enum.dart';

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
    } on NetworkException catch (e) {
      // This block will catch the `NetworkException`
      if (e.type == NetworkExceptionType.requestTimeOut) {
        returnresponse.add('1');
        returnresponse.add(e.message);
        // Handle the timeout specifically
        print('Timeout occurred: ${e.errorMessage}');
      } else {
        returnresponse.add('1');
        returnresponse.add(e.message);
        // Handle other types of NetworkException
        print('Network Exception: ${e.errorMessage}');
      }
    } catch (e) {
      if (e is NetworkException) {
        log('Network exception: ${e.errorMessage}');
        NetworkException exp = e;
        print(e);

        returnresponse.add('1');
        returnresponse.add(exp.message);
        log(e.toString());
        // Handle the network error message here in the UI or show an alert
      } else {
        log('Unhandled exception: $e');
        // Handle other exceptions
      }
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
