import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:h_smart/features/auth/domain/entities/loginResponse.dart';
import 'package:http/http.dart' as http;
import 'package:h_smart/features/auth/domain/entities/completeprofileRes.dart';
import 'package:h_smart/features/auth/domain/entities/createaccount.dart';
import 'package:h_smart/features/auth/domain/entities/setuphealthissue.dart';
import 'package:h_smart/features/auth/domain/repositories/authrepo.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/loginmodel.dart';
import '../../domain/usecases/authStates.dart';

class Authprovider extends ChangeNotifier {
  final AuthRepository authReposity;

  Authprovider(this.authReposity);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? image;
  bool uploadimageerror = false;
  bool getinfo1 = false;
  String email = '';
  String profilepic = '';
  String firstname = '';
  bool logoutuser = false;
  DateTime dob = DateTime.now();
  bool infoloading = true;
  String lastname = '';
  String address = '';
  String phone = '';
  String? imageurl;
  String es = '';
  bool imageloading = false;
  Data getData = Data(
      id: '',
      user: '',
      firstName: '',
      couldinaryFileField: '',
      lastName: '',
      dateOfBirth: DateTime.now(),
      address: '',
      contactNumber: '',
      hospital: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());
  final dio = Dio();

  LoginResult loginResult =
      LoginResult(LoginResultStates.isIdle, LoginResponse());
  VerifyEmailResult verifyEmailResult =
      VerifyEmailResult(VerifyEmailResultStates.isIdle, {});
  GetInfoResult getInfoResult = GetInfoResult(GetInfoResultStates.isIdle, {});

  RegisterResult registerResult =
      RegisterResult(RegisterResultStates.isIdle, {});
  SetUpHealthResult setUpHealthResult =
      SetUpHealthResult(SetUpHealthResultStates.isIdle, {});
  ContinueRegisterResult continueRegisterResult =
      ContinueRegisterResult(ContinueRegisterResultStates.isIdle, {});

  Map<String, dynamic> userData = {
    "firstname": "",
    "lastname": "",
    "userId": "",
    "email": "",
    "imageUrl": "",
    "trading_experience": "",
    "phoneNumber": "",
    "verified": "",
    "token": "",
    "planId": "",
    "dateExpired": "",
    "datebought": ""
  };

  Future<void> getUserObject() async {
    final pref = await SharedPreferences.getInstance(); // Await the instance

    final String? firstname = pref.getString("firstname");
    final String? lastname = pref.getString("lastname");
    final String? email = pref.getString("email");
    final String? profile_id = pref.getString("profile_id");
    final String? imageUrl = pref.getString("profilepic");
    final String? phoneNumber = pref.getString("phone");
    final String? token = pref.getString("jwt_token");
    userData.addAll({
      "firstname": firstname ?? "",
      "lastname": lastname ?? "",
      "email": email ?? "",
      "profile_id": profile_id ?? "",
      "imageUrl": imageUrl ?? "",
      "phoneNumber": phoneNumber ?? "",
      "token": token ?? "",
    });
    notifyListeners();
    print(userData); // Check if the data is stored correctly
  }

  Future<void> login(email, password) async {
    LoginModel login = LoginModel(email: email, password: password);
    loginResult = LoginResult(LoginResultStates.isLoading, LoginResponse());
    notifyListeners();

    final response = await authReposity.login(login);
    logoutuser = false;
    if (response.state == LoginResultStates.isData) {
      final token = response.response.accessToken;
      final pref = await SharedPreferences.getInstance();
      pref.setString('jwt_token', token ?? '');
    }
    loginResult = response;

    notifyListeners();
  }

  Future<void> verifyOtp(otp) async {
    verifyEmailResult =
        VerifyEmailResult(VerifyEmailResultStates.isLoading, {});
    notifyListeners();

    final response = await authReposity.Verifyemail(otp);
    verifyEmailResult = response;

    notifyListeners();
  }

  Future<void> getinfo() async {
    final pref = await SharedPreferences.getInstance();
    email = pref.getString('email') ?? '';

    getInfoResult = GetInfoResult(GetInfoResultStates.isLoading, {});
    notifyListeners();
    final response = await authReposity.getinfo();
    getInfoResult = response;
    if (response.state == GetInfoResultStates.isError) {
      if (response.response['message'].contains('Given token not valid') ||
          response.response['message'].contains('User not found')) {
        setstaticinfo();
        logoutuser = true;
      }
    } else {
      setstaticinfo();
      List data = response.response['data'];
      final decodedres = Data.fromJson(data[0]);

      getData = decodedres;

      pref.setString('profile_id', getData.id);

      pref.setString('email', getData.user);
      email = getData.user;

      pref.setString('profilepic', getData.couldinaryFileField);
      profilepic = getData.couldinaryFileField;

      pref.setString('first_name', getData.firstName);
      firstname = getData.firstName;
      pref.setString('last_name', getData.lastName);
      lastname = getData.lastName;
      pref.setString('address', getData.address);
      address = getData.address;
      pref.setString('phone', getData.contactNumber);
      phone = getData.contactNumber;

      dob = getData.dateOfBirth;
    }

    notifyListeners();
  }

  void logout() async {
    getinfo1 = false;
    final pref = await SharedPreferences.getInstance();
    pref.remove('profile_id');
    pref.remove('email');
    pref.remove('first_name');
    pref.remove('last_name');
    pref.remove('address');
    pref.remove('phone');
    pref.remove('jwt_token');
    email = '';
    profilepic = '';
    firstname = '';
    lastname = '';
    address = '';
    phone = '';
    notifyListeners();
  }

  Future<void> register(email, password) async {
    registerResult = RegisterResult(RegisterResultStates.isLoading, {});
    notifyListeners();
    Registermodel reg = Registermodel(email: email, password: password);
    final response = await authReposity.createacount(reg);
    registerResult = response;

    if (response.state == RegisterResultStates.isData) {
      final pref = await SharedPreferences.getInstance();
      String token = response.response['access_token'];
      // pref.setString('jwt_token', token);
    }
    notifyListeners();
  }

  Future<void> setupHealthIssue(gender, bloodtype, allergies, chronic) async {
    setUpHealthResult =
        SetUpHealthResult(SetUpHealthResultStates.isLoading, {});
    notifyListeners();

    SetUpHealthIssue setUpHealthIssue = SetUpHealthIssue(
        sex: gender,
        bloodType: bloodtype,
        allergies: allergies,
        chronicConditions: chronic);
    final response = await authReposity.setuphealthissues(setUpHealthIssue);
    setUpHealthResult = response;
    notifyListeners();
  }

  Future<void> pickimage() async {
    try {
      imageloading = true;
      notifyListeners();
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) {
        return;
      }
      final ImageTemporary = File(result.path);

      image = ImageTemporary;
      print(image);
    } catch (e) {
      imageloading = false;
      es = e.toString();
    } finally {
      imageloading = false; // Stop loading
      notifyListeners();
    }
    notifyListeners();
  }

  void setstaticinfo() {
    getinfo1 = true;
    notifyListeners();
  }

  Future<void> uploadImage(String firstname, String lastname, String phone,
      DateTime dob, String address) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlsavisdq/upload');
    try {
      if (image != null) {
        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'image_preset_hSmart'
          ..files.add(await http.MultipartFile.fromPath('file', image!.path));

        // Apply a timeout of 15 seconds
        final response = await request.send().timeout(Duration(seconds: 15));

        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          final jsonMap = jsonDecode(responseString);

          final url = jsonMap['url'];
          imageurl = url;
          await continueRegistration(firstname, lastname, phone, dob, address);
        } else {
          imageurl = null;
          continueRegisterResult = ContinueRegisterResult(
              ContinueRegisterResultStates.isError,
              {"message": "Something Went Wrong"});
        }
      } else {
        continueRegisterResult = ContinueRegisterResult(
            ContinueRegisterResultStates.isError,
            {"message": "No image is selected"});
      }
    } catch (e) {
      if (e is TimeoutException) {
        continueRegisterResult = ContinueRegisterResult(
            ContinueRegisterResultStates.isError,
            {"message": "Request timed out"});
      } else {
        continueRegisterResult = ContinueRegisterResult(
            ContinueRegisterResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }

    notifyListeners();
  }

  Future<void> continueRegistration(String firstname, String lastname,
      String phone, DateTime dob, String address) async {
    continueRegisterResult =
        ContinueRegisterResult(ContinueRegisterResultStates.isLoading, {});
    notifyListeners();

    final response = await authReposity.continueRegistration(
        firstname, lastname, phone, dob, address, image!, imageurl);

    continueRegisterResult = response;
    if (response.state == ContinueRegisterResultStates.isData) {
      Map<String, dynamic> data = response.response['data'];
      final decodedres = Data.fromJson(data);
      getData = decodedres;
      final pref = await SharedPreferences.getInstance();
      pref.setString('profile_id', getData.id);
      pref.setString('email', getData.user);
      pref.setString('first_name', getData.firstName);
      pref.setString('last_name', getData.lastName);
    }

    notifyListeners();
  }
}
