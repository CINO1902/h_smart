import 'dart:io';

import 'package:dio/dio.dart';
import 'package:h_smart/core/service/http_service.dart';
import 'package:h_smart/features/auth/data/repositories/auth_repo.dart';
import 'package:h_smart/features/auth/domain/entities/loginResponse.dart';
import 'package:h_smart/features/auth/domain/entities/loginmodel.dart';
import 'package:h_smart/features/auth/domain/entities/setuphealthissue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/enum.dart';
import '../../domain/entities/createaccount.dart';
import '../../domain/usecases/authStates.dart';

class AuthDatasourceImp implements AuthDatasource {
  final HttpService httpService;

  AuthDatasourceImp(this.httpService);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult =
        RegisterResult(RegisterResultStates.isLoading, {});
    final response = await httpService.request(
        url: '/Auth-Operation/register/',
        methodrequest: RequestMethod.post,
        data: registermodelToJson(createaccount));

    if (response.statusCode == 201) {
      final user_id = response.data['user']['id'];
      final pref = await SharedPreferences.getInstance();
      // print(user_id);
      pref.setString('user_id', user_id);
      // token = response.data['access_token'];
      registerResult =
          RegisterResult(RegisterResultStates.isData, response.data);
    }

    return registerResult;
  }

  @override
  Future<LoginResult> login(login) async {
    LoginResult loginResult =
        LoginResult(LoginResultStates.isLoading, LoginResponse());

    final response = await httpService.request(
        url: '/Auth-Operation/login/',
        methodrequest: RequestMethod.post,
        data: loginModelToJson(login));

    if (response.statusCode == 200) {
      final decodedresponse = LoginResponse.fromJson(response.data);
      loginResult = LoginResult(LoginResultStates.isData, decodedresponse);
    }

    return loginResult;
  }

  @override
  Future<ContinueRegisterResult> continueRegistration(
      firstname, lastname, phone, dob, address, File image, imageurl) async {
    ContinueRegisterResult continueRegisterResult =
        ContinueRegisterResult(ContinueRegisterResultStates.isLoading, {});
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
      continueRegisterResult = ContinueRegisterResult(
          ContinueRegisterResultStates.isData, response.data);
    }

    return continueRegisterResult;
  }

  @override
  Future<VerifyEmailResult> Verifyemail(otp) async {
    VerifyEmailResult verifyEmailResult =
        VerifyEmailResult(VerifyEmailResultStates.isLoading, {});
    final pref = await SharedPreferences.getInstance();
    String userid = pref.getString('user_id') ?? '';
    final response = await httpService.request(
        url: '/Auth-Operation/Verfy-Account/$userid/',
        methodrequest: RequestMethod.post,
        data: {
          "token": otp,
        });

    if (response.statusCode == 200) {
      verifyEmailResult =
          VerifyEmailResult(VerifyEmailResultStates.isData, response.data);
    }

    return verifyEmailResult;
  }

  @override
  Future<SetUpHealthResult> setuphealthissues(setup) async {
    SetUpHealthResult setUpHealthResult =
        SetUpHealthResult(SetUpHealthResultStates.isLoading, {});

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
      setUpHealthResult =
          SetUpHealthResult(SetUpHealthResultStates.isData, response.data);
    }

    return setUpHealthResult;
  }

  @override
  Future<GetInfoResult> getinfo() async {
    GetInfoResult getInfoResult =
        GetInfoResult(GetInfoResultStates.isLoading, {});
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
      getInfoResult = GetInfoResult(GetInfoResultStates.isData, response.data);
    }

    return getInfoResult;
  }
}
