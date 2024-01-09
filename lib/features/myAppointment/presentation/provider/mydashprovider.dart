import 'dart:io';

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

  Future<void> pickimageupdate() async {
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

  Future<void> editprofile(firstname, lastname, phone, email, address) async {
    loading = true;

    final response = await userRepository.edit_profile(
        firstname, lastname, phone, email, address, image);
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
