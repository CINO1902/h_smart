import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:h_smart/features/auth/domain/entities/completeProfile.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/myAppointment/domain/repositories/user_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mydashprovider extends ChangeNotifier {
  final UserRepository userRepository;

  mydashprovider(this.userRepository);
  bool loading = false;
  bool error = false;
  bool uploadimageerror = false;
  String message = '';
  String email = '';
  String profilepic = '';
  String firstname = '';
  String es = '';
  DateTime dob = DateTime.now();
  File? image;
  String lastname = '';
  String address = '';
  String phone = '';
  String imageurl = '';

  Future<void> pickimageupdate() async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (result == null) {
      //   return;
      // }
      final ImageTemporary = File(result!.path);

      image = ImageTemporary;
    } catch (e) {
      error = true;
      es = e.toString();
      print(es);
    }
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

  Future<void> editprofile(firstname, lastname, phone, email, address) async {
    loading = true;

    final response = await userRepository.edit_profile(
        firstname, lastname, phone, email, address, image, imageurl);
    if (response[0].contains('1')) {
      error = false;
      message = response[1];
    } else {
      error = true;
      message = response[1];
    }
    final pref = await SharedPreferences.getInstance();
    pref.setBool('prfilepicset', false);
    loading = false;
    notifyListeners();
  }

  void update(authprovider authprovider) {}
}
