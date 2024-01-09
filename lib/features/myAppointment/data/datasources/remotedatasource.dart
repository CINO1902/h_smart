import 'dart:io';

import 'package:dio/dio.dart';
import 'package:h_smart/core/service/http_service.dart';

import 'package:h_smart/features/myAppointment/data/repositories/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/enum.dart';

class UserDatasourceImpl implements UserDataSource {
  final HttpService httpService;

  UserDatasourceImpl(this.httpService);

  @override
  Future<List<String>> edit_profile(
      firstname, lastname, phone, email, address, File? image) async {
    String result = '';
    String msg = '';

    final content =
        image != null ? await MultipartFile.fromFile(image.path) : '';
    FormData form = FormData.fromMap({
      'profile_picture': content,
      'first_name': firstname,
      'last_name': lastname,
      'address': address,
      'contact_number': phone
    });

    List<String> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
      'content-Type': "multipart/form-data",
      "Accept": "*/*",
      "connection": "keep-alive"
    };

    String profile_id = pref.getString('profile_id') ?? '';

    FormData form1 = FormData.fromMap({
      'first_name': firstname,
      'last_name': lastname,
      'address': address,
      'contact_number': phone
    });

    final response = await httpService.request(
      url: '/User-Profile/$profile_id/',
      methodrequest: RequestMethod.patch,
      data: image != null ? form : form1,
    );

    if (response.statusCode == 200) {
      result = '1';
      msg = 'Updated';

      returnvalue.add(result);
      returnvalue.add(msg);
    }

    return returnvalue;
  }
}
