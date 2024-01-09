import 'dart:developer';

import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';

import '../../../../core/exceptions/network_exception.dart';

abstract class DoctorRepository {
  Future<List<dynamic>> getDoctorList();
  Future<List<dynamic>> getDoctorCategory();
  Future<List<dynamic>> addtofav(id);
  Future<List<dynamic>> mydoctor();
  Future<List<dynamic>> removefav(id);
}

class DoctorRepoImpl implements DoctorRepository {
  final DoctorDatasource doctorDatasource;

  DoctorRepoImpl(this.doctorDatasource);

  @override
  Future<List<dynamic>> getDoctorList() async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.getDoctorList();
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
  Future<List> getDoctorCategory() async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.getDoctorCategory();
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List> addtofav(id) async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.addtofav(id);
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List> mydoctor() async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.mydoctor();
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }

  @override
  Future<List> removefav(id) async {
    List<dynamic> returnresponse = [];

    try {
      returnresponse = await doctorDatasource.removefav(id);
    } catch (e) {
      NetworkException exp = e as NetworkException;

      returnresponse.add('1');
      returnresponse.add(exp.message);

      log(e.toString());
    }
    return returnresponse;
  }
}
