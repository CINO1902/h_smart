import 'dart:io';

import 'package:dio/dio.dart';
import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';
import 'package:h_smart/features/myAppointment/data/repositories/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';

class DoctorDatasourceImp implements DoctorDatasource {
  final HttpService httpService;
  DoctorDatasourceImp(this.httpService);

  @override
  Future<List> getDoctorList() async {
    String result = '';
    String msg = '';
    Map<String, dynamic> data = {};
    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
      url: '/Doctor-List/',
      methodrequest: RequestMethod.get,
    );
    print(response);
    if (response.statusCode == 200) {
      result = '1';
      msg = response.data['message'];
      data = response.data['data'];

      returnvalue.add(result);
      returnvalue.add(msg);
      returnvalue.add(data);
    }

    return returnvalue;
  }

  @override
  Future<List> getDoctorCategory() async {
    String result = '';

    List<dynamic> returnvalue = [];

    final response = await httpService.request(
      url: '/Specialization-Operation/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }

  @override
  Future<List> addtofav(id) async {
    String result = '';

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
        url: '/my-doctor/',
        methodrequest: RequestMethod.post,
        data: {'doctor': id});

    if (response.statusCode == 201) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }

  @override
  Future<List> mydoctor() async {
    String result = '';

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
      url: '/my/doctor/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }

  @override
  Future<List> removefav(id) async {
    String result = '';

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
    };
    final response = await httpService.request(
      url: '/my/doctor/$id/',
      methodrequest: RequestMethod.delete,
    );

    if (response.statusCode == 204) {
      result = '2';

      returnvalue.add(result);
      returnvalue.add(response.data);
    }

    return returnvalue;
  }
}
