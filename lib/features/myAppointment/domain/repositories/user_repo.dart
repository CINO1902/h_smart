import 'dart:developer';
import 'dart:io';

import 'package:h_smart/features/myAppointment/data/repositories/user_repo.dart';

import '../../../../core/exceptions/network_exception.dart';

abstract class UserRepository {
  Future<List<String>> edit_profile(
      firstname, lastname, phone, email, address, File? image, imagelink);
}

class UserRepositoryImp implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImp(this.userDataSource);

  @override
  Future<List<String>> edit_profile(
      firstname, lastname, phone, email, address, File? image, imagelink) async {
    List<String> returnresponse = [];

    try {
      returnresponse = await userDataSource.edit_profile(
          firstname, lastname, phone, email, address, image, imagelink);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;

      returnresponse.add('2');
      returnresponse.add(exp.errorMessage!);
    }
    return returnresponse;
  }
}
