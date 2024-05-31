import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';
import 'package:h_smart/features/auth/domain/entities/completeProfile.dart';
import 'package:h_smart/features/auth/domain/entities/loginmodel.dart';
import 'package:h_smart/features/auth/domain/entities/setuphealthissue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/enum.dart';
import '../../domain/entities/createaccount.dart';

class AuthDatasourceImp implements AuthDatasource {
  final HttpService httpService;

  AuthDatasourceImp(this.httpService);
  @override
  Future<List<String>> createacount(createaccount) async {
    String result = '';
    String msg = '';
    String token = '';
    List<String> returnvalue = [];

    final response = await httpService.request(
        url: '/Auth-Operation/register/',
        methodrequest: RequestMethod.post,
        data: registermodelToJson(createaccount));

    if (response.statusCode == 201) {
      result = '1';
      msg = 'Account Created';
      final user_id = response.data['user']['id'];
      final pref = await SharedPreferences.getInstance();
      print(user_id);
      pref.setString('user_id', user_id);
      token = response.data['access_token'];
      returnvalue.add(result);
      returnvalue.add(msg);
      returnvalue.add(token);
    }

    return returnvalue;
  }

  @override
  Future<List<String>> login(login) async {
    String result = '';
    String msg = '';
    String token = '';
    List<String> returnvalue = [];

    final response = await httpService.request(
        url: '/Auth-Operation/login/',
        methodrequest: RequestMethod.post,
        data: loginModelToJson(login));

    if (response.statusCode == 200) {
      result = '2';
      msg = response.data['message'];
      token = response.data['access_token'];
      returnvalue.add(result);
      returnvalue.add(msg);
      returnvalue.add(token);
    }

    return returnvalue;
  }

  @override
  Future<List<dynamic>> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl) async {
    String result = '';
    String msg = '';
    Map<String, dynamic> data = {};
    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    // final url = Uri.parse('https://api.cloudinary.com/v1_1/dlsavisdq/upload');
    // final request = http.MultipartRequest('POST', url)
    //   ..fields['upload_preset'] = 'image_preset_hSmart'
    //   ..files.add(await http.MultipartFile.fromPath('file', image.path));
    // final response1 = await request.send();

    // final responseData = await response1.stream.toBytes();
    // final responseString = String.fromCharCodes(responseData);
    // final jsonMap = jsonDecode(responseString);

    // final url1 = jsonMap['url'];

    // final content = await MultipartFile.fromFile(image.path);
    httpService.header = {
      'Authorization': 'Bearer $token',
      'content-Type': "multipart/form-data",
      "Accept": "*/*",
      "connection": "keep-alive"
    };

    final response = await httpService.request(
      url: '/User-Profile/',
      methodrequest: RequestMethod.post,
      data: FormData.fromMap({
        'couldinary_file_field': imageurl,
        'first_name': firstname,
        'last_name': lastname,
        'date_of_birth':
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        'address': address,
        'contact_number': phone,
      }),
    );

    if (response.statusCode == 201) {
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
  Future<List<String>> Verifyemail(otp) async {
    String result = '';
    String msg = '';

    List<String> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String userid = pref.getString('user_id') ?? '';
    final response = await httpService.request(
        url: '/Auth-Operation/Verfy-Account/$userid/',
        methodrequest: RequestMethod.post,
        data: {
          "token": otp,
        });

    if (response.statusCode == 200) {
      result = '2';
      msg = response.data['message'];

      returnvalue.add(result);
      returnvalue.add(msg);
    }

    return returnvalue;
  }

  @override
  Future<List<String>> setuphealthissues(setup) async {
    String result = '';
    String msg = '';

    List<String> returnvalue = [];
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
      result = '2';
      msg = response.data['message'];
      returnvalue.add(result);
      returnvalue.add(msg);
    }

    return returnvalue;
  }

  @override
  Future<List<dynamic>> getinfo() async {
    String result = '';
    Map<String, dynamic> data = {};

    List<dynamic> returnvalue = [];
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString('jwt_token') ?? '';
    httpService.header = {
      'Authorization': 'Bearer $token',
      'content-Type': 'application/json',
    };
    final response = await httpService.request(
      url: '/User-Profile/',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      result = '2';
      data = response.data['data'][0];
      returnvalue.add(result);
      returnvalue.add(data);
    }

    return returnvalue;
  }
}
