import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:h_smart/constant/network_api.dart';
import 'package:h_smart/features/myAppointment/domain/entities/editProfie.dart';
import 'package:h_smart/features/myAppointment/domain/usecases/appointmentStates.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:h_smart/features/myAppointment/domain/repositories/user_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class Mydashprovider extends ChangeNotifier {
  final UserRepository userRepository;

  Mydashprovider(this.userRepository);

  String message = '';
  String email = '';
  String profilepic = '';
  String firstname = '';
  DateTime dob = DateTime.now();
  File? image;
  String lastname = '';
  String address = '';
  String phone = '';
  String imageurl = '';
  String phoneNumber = '';
  String? updateImageUrl;
  UploadImageResult uploadImageResult = UploadImageResult(
    UploadImageResultStates.isIdle,
    '',
  );

  UpdateProfileResult updateProfileResult = UpdateProfileResult(
    UpdateProfileResultStates.isIdle,
    '',
  );
  Future<void> pickimageupdate() async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (result == null) {
      //   return;
      // }
      final ImageTemporary = File(result!.path);

      image = ImageTemporary;
    } catch (e) {}
    notifyListeners();
  }

  void splitNumberPureDart(String raw) {
    try {
      final parsed = PhoneNumber.parse(raw);

      // parsed.countryCode is an int (e.g. 1, 44, 234, etc.)
      // parsed.nsn         is the rest of the digits (national significant number)
      print('Country code : +${parsed.countryCode}');
      print('Subscriber   : ${parsed.nsn}');
      phoneNumber = parsed.nsn;
      notifyListeners();
    } catch (e) {
      print('Could not parse "$raw": $e');
    }
  }

  Future<void> uploadimage() async {
    uploadImageResult = UploadImageResult(
      UploadImageResultStates.isLoading,
      '',
    );
    notifyListeners();
    final uri = Uri.parse(
      '$baseImageUrl/upload?privacy_level=public',
    );

    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            image!.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 15));
      print('update image response $streamedResponse');
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        throw Exception(
            'Image upload failed with status ${streamedResponse.statusCode}');
      }

      final jsonMap = jsonDecode(responseBody) as Map<String, dynamic>;
      final returnedUrl = jsonMap['payload']['file_url'] as String?;
      image = null;
      updateImageUrl = returnedUrl;
      if (returnedUrl == null) {
        throw Exception('Upload succeeded but no URL returned');
      }

      uploadImageResult = UploadImageResult(
        UploadImageResultStates.isData,
        'Success',
      );
    } on TimeoutException {
      uploadImageResult = UploadImageResult(
        UploadImageResultStates.isIdle,
        'Request Timed out',
      );
    } catch (e) {
      uploadImageResult = UploadImageResult(
        UploadImageResultStates.isIdle,
        'Something went wrong',
      );
    }

    notifyListeners();
  }

  Future<void> editprofile(firstname, lastname, phone, address) async {
    updateProfileResult = UpdateProfileResult(
      UpdateProfileResultStates.isLoading,
      '',
    );
    EditProfile editProfile = EditProfile(
        firstName: firstname,
        lastName: lastname,
        profileUrl: updateImageUrl,
        address: address);

    final response = await userRepository.edit_profile(editProfile);
    updateProfileResult = response;
    notifyListeners();
  }
}
