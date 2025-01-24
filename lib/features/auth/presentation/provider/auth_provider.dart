import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:h_smart/features/auth/domain/entities/completeprofileRes.dart';
import 'package:h_smart/features/auth/domain/entities/createaccount.dart';
import 'package:h_smart/features/auth/domain/entities/setuphealthissue.dart';
import 'package:h_smart/features/auth/domain/repositories/authrepo.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/loginmodel.dart';

class authprovider extends ChangeNotifier {
  final AuthRepository authReposity;

  authprovider(this.authReposity);
  bool error = false;

  String message = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? image;
  bool loading = false;
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
  String imageurl = '';
  String es = '';
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
  Future<void> login(email, password) async {
    LoginModel login = LoginModel(email: email, password: password);
    loading = true;
    notifyListeners();

    final response = await authReposity.login(login);
    logoutuser = false;
    if (response[0].contains('1')) {
      print('error is here');
      error = true;
      message = response[1];
    } else {
      error = false;
      message = response[1];
      String token = response[2];
      final pref = await SharedPreferences.getInstance();
      pref.setString('jwt_token', token);
    }
    loading = false;

    notifyListeners();
  }

  Future<void> verifyOtp(otp) async {
    loading = true;
    notifyListeners();

    final response = await authReposity.Verifyemail(otp);
    if (response[0].contains('1')) {
      error = true;
      message = response[1];
    } else {
      error = false;
      message = response[1];
    }
    loading = false;
    notifyListeners();
  }

  Future<void> getinfo() async {
    final pref = await SharedPreferences.getInstance();
    email = pref.getString('email') ?? '';
    error = false;
    message = '';
    infoloading = true;

    final response = await authReposity.getinfo();
    print(response);
    if (response[0].contains('1')) {
      error = true;

      if (response[1].contains('Given token not valid') ||
          response[1].contains('User not found')) {
        logoutuser = true;
      }
    } else {
      error = false;
      Map<String, dynamic> data = response[1];
      final decodedres = Data.fromJson(data);

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
      _firestore.collection('users').doc(email).set({
        'id': email,
        'profile_pic': getData.couldinaryFileField,
        'first_name': getData.firstName,
        'last_name': getData.lastName
      }, SetOptions(merge: true));
    }
    infoloading = false;
    setstaticinfo();
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
    error = false;
    message = '';
    loading = true;
    notifyListeners();
    Registermodel reg = Registermodel(email: email, password: password);
    final response = await authReposity.createacount(reg);
    if (response[0].contains('2')) {
      error = true;
      message = response[1];
    } else {
      error = false;
      message = "Registration Successful";
      final pref = await SharedPreferences.getInstance();
      String token = response[2];
      pref.setString('jwt_token', token);
    }
    loading = false;
    notifyListeners();
  }

  Future<void> setupHealthIssue(gender, bloodtype, allergies, chronic) async {
    error = false;
    message = '';
    loading = true;
    notifyListeners();
    print(gender);
    SetUpHealthIssue setUpHealthIssue = SetUpHealthIssue(
        sex: gender,
        bloodType: bloodtype,
        allergies: allergies,
        chronicConditions: chronic);
    final response = await authReposity.setuphealthissues(setUpHealthIssue);
    if (response[0].contains('1')) {
      error = true;
      message = response[1];
    } else {
      error = false;
      message = response[1];
    }
    loading = false;
    notifyListeners();
  }

  Future<void> pickimage() async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) {
        return;
      }
      final ImageTemporary = File(result.path);

      image = ImageTemporary;
      print(image);
    } catch (e) {
      error = true;
      es = e.toString();
    }
    notifyListeners();
  }

  void setstaticinfo() {
    getinfo1 = true;
    notifyListeners();
  }

  Future<void> uploadbook() async {
    uploadimageerror = false;
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlsavisdq/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'image_preset_hSmart'
      ..files.add(await http.MultipartFile.fromPath('file', image!.path));
    final response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      final url = jsonMap['url'];
      imageurl = url;
    } else {
      uploadimageerror = true;
    }
    notifyListeners();
  }

  Future<void> continueRegistration(String firstname, String lastname,
      String phone, DateTime dob, String address) async {
    error = false;
    message = '';
    loading = true;
    notifyListeners();

    final response = await authReposity.continueRegistration(
        firstname, lastname, phone, dob, address, image!, imageurl);
    if (response[0].contains('2')) {
      error = true;
      message = response[1];
    } else {
      error = false;
      message = response[1];
      Map<String, dynamic> data = response[2];
      final decodedres = Data.fromJson(data);

      getData = decodedres;
      final pref = await SharedPreferences.getInstance();
      pref.setString('profile_id', getData.id);
      pref.setString('email', getData.user);
      pref.setString('first_name', getData.firstName);
      pref.setString('last_name', getData.lastName);
      print(getData.id);
    }
    loading = false;
    notifyListeners();
  }
}
