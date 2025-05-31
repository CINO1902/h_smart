import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:h_smart/features/auth/domain/entities/ContinueRegistrationModel.dart';
import 'package:h_smart/features/auth/domain/entities/createaccount.dart';
import 'package:h_smart/features/auth/domain/entities/loginResponse.dart';
import 'package:h_smart/features/auth/domain/entities/loginmodel.dart';
import 'package:h_smart/features/auth/domain/entities/completeprofileRes.dart';
import 'package:h_smart/features/auth/domain/repositories/authrepo.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class responsible for all authentication-related operations,
/// including login, registration, OTP verification, and user profile management.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authRepository);

  final AuthRepository _authRepository;

  /// Local state fields
  File? _profileImage;
  bool _isImageLoading = false;
  bool _uploadImageError = false;
  bool _isLoggedOut = false;
  bool _infoLoading = true;
  bool _hasFetchedInfo = false;

  String _email = '';
  String _profilePicUrl = '';
  String _firstName = '';
  String _lastName = '';
  String _address = '';
  String _phone = '';
  DateTime _dateOfBirth = DateTime.now();

  /// Controllers for image picking and other async tasks
  final ImagePicker _imagePicker = ImagePicker();

  /// Result states for various API calls
  LoginResult loginResult = LoginResult(
    LoginResultStates.isIdle,
    LoginResponse(),
  );
  VerifyEmailResult verifyEmailResult = VerifyEmailResult(
    VerifyEmailResultStates.isIdle,
    {},
  );
  GetInfoResult getInfoResult = GetInfoResult(
    GetInfoResultStates.isIdle,
    {},
  );
  RegisterResult registerResult = RegisterResult(
    RegisterResultStates.isIdle,
    {},
  );

    EmailVerificationResult emailVerificationResult = EmailVerificationResult(
    EmailVerificationResultState.isIdle,
    {},
  );
  SetUpHealthResult setUpHealthResult = SetUpHealthResult(
    SetUpHealthResultStates.isIdle,
    {},
  );
  ContinueRegisterResult continueRegisterResult = ContinueRegisterResult(
    ContinueRegisterResultStates.isIdle,
    {},
  );

  /// Data model for the fetched user
  Data _userData = Data(
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
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> _localUserData = {
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
    "datebought": "",
  };

  /// Getters for private fields
  File? get profileImage => _profileImage;
  bool get isImageLoading => _isImageLoading;
  bool get uploadImageError => _uploadImageError;
  bool get isLoggedOut => _isLoggedOut;
  bool get infoLoading => _infoLoading;
  bool get hasFetchedInfo => _hasFetchedInfo;

  String get email => _email;
  String get profilePicUrl => _profilePicUrl;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get address => _address;
  String get phone => _phone;
  DateTime get dateOfBirth => _dateOfBirth;

  Data get userData => _userData;
  Map<String, dynamic> get localUserData => _localUserData;

  /// Fetches stored user info from SharedPreferences and updates localUserData
  Future<void> retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _localUserData = {
      "firstname": prefs.getString("firstname") ?? "",
      "lastname": prefs.getString("lastname") ?? "",
      "email": prefs.getString("email") ?? "",
      "profile_id": prefs.getString("profile_id") ?? "",
      "imageUrl": prefs.getString("profilepic") ?? "",
      "phoneNumber": prefs.getString("phone") ?? "",
      "token": prefs.getString("jwt_token") ?? "",
    };
    notifyListeners();
  }

  /// Performs login and stores JWT on success
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final loginModel = LoginModel(email: email, password: password);
    loginResult = LoginResult(LoginResultStates.isLoading, LoginResponse());
    notifyListeners();

    final response = await _authRepository.login(loginModel);
    _isLoggedOut = false;

    if (response.state == LoginResultStates.isData) {
      final token = response.response.payload?.accessToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token ?? '');
    }
    loginResult = response;
    notifyListeners();
  }

  /// Verifies OTP for email verification
  Future<void> verifyOtp(String otp) async {
    verifyEmailResult = VerifyEmailResult(
      VerifyEmailResultStates.isLoading,
      {},
    );
    notifyListeners();

    final response = await _authRepository.Verifyemail(otp);
    verifyEmailResult = response;
    notifyListeners();
  }

  /// Fetches user info from backend and caches into SharedPreferences
  Future<void> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('email') ?? '';

    getInfoResult = GetInfoResult(GetInfoResultStates.isLoading, {});
    notifyListeners();

    final response = await _authRepository.getinfo();
    getInfoResult = response;

    if (response.state == GetInfoResultStates.isError) {
      final message = response.response['message'] as String? ?? '';
      if (message.contains('Given token not valid') ||
          message.contains('User not found')) {
        _resetStaticInfo();
        _isLoggedOut = true;
      }
    } else {
      _resetStaticInfo();
      final dataList = response.response['data'] as List<dynamic>;
      final decodedData = Data.fromJson(dataList[0] as Map<String, dynamic>);
      _userData = decodedData;

      await prefs.setString('profile_id', _userData.id);
      await prefs.setString('email', _userData.user);
      _email = _userData.user;

      await prefs.setString('profilepic', _userData.couldinaryFileField);
      _profilePicUrl = _userData.couldinaryFileField;

      await prefs.setString('first_name', _userData.firstName);
      _firstName = _userData.firstName;

      await prefs.setString('last_name', _userData.lastName);
      _lastName = _userData.lastName;

      await prefs.setString('address', _userData.address);
      _address = _userData.address;

      await prefs.setString('phone', _userData.contactNumber);
      _phone = _userData.contactNumber;

      _dateOfBirth = _userData.dateOfBirth;
    }

    notifyListeners();
  }

  /// Clears user data on logout
  Future<void> logout() async {
    _hasFetchedInfo = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_id');
    await prefs.remove('email');
    await prefs.remove('first_name');
    await prefs.remove('last_name');
    await prefs.remove('address');
    await prefs.remove('phone');
    await prefs.remove('jwt_token');

    _email = '';
    _profilePicUrl = '';
    _firstName = '';
    _lastName = '';
    _address = '';
    _phone = '';
    _isLoggedOut = false;
    notifyListeners();
  }

  /// Handles user registration
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) async {
    registerResult = RegisterResult(
      RegisterResultStates.isLoading,
      {},
    );
    notifyListeners();

    final registerModel = Registermodel(
      email: email,
      password: password,
      firstname: firstName,
      lastname: lastName,
      phoneNumber: phone,
    );
    final response = await _authRepository.createacount(registerModel);
    registerResult = response;
    notifyListeners();
  }

    /// Handles user registration
  Future<void> callActivation({

    required String email

  }) async {
    emailVerificationResult = EmailVerificationResult(
      EmailVerificationResultState.isLoading,
      {},
    );
    notifyListeners();


    final response = await _authRepository.createacount(email);
    registerResult = response;
    notifyListeners();
  }

  /// Picks an image from the gallery for profile upload
  Future<void> pickImage() async {
    try {
      _isImageLoading = true;
      notifyListeners();

      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      _profileImage = File(pickedFile.path);
    } catch (e) {
      _uploadImageError = true;
    } finally {
      _isImageLoading = false;
      notifyListeners();
    }
  }

  /// Uploads profile image and continues registration
  Future<void> uploadProfile({
    required String gender,
    required DateTime dob,
    required String address,
    String? bloodType,
    String? emergencyContactName,
    required String emergencyContactPhone,
    required List<String?> allergies,
    required List<String?> medicalConditions,
  }) async {
    continueRegisterResult = ContinueRegisterResult(
      ContinueRegisterResultStates.isLoading,
      {},
    );
    notifyListeners();

    if (_profileImage == null) {
      continueRegisterResult = ContinueRegisterResult(
        ContinueRegisterResultStates.isError,
        {'message': 'No image selected'},
      );
      notifyListeners();
      return;
    }

    final uri = Uri.parse(
      'http://38.242.146.4:8030/api/v1/upload?privacy_level=public',
    );

    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            _profileImage!.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 15));
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        throw Exception(
            'Image upload failed with status ${streamedResponse.statusCode}');
      }

      final jsonMap = jsonDecode(responseBody) as Map<String, dynamic>;
      final returnedUrl = jsonMap['payload']['file_url'] as String?;
      if (returnedUrl == null) {
        throw Exception('Upload succeeded but no URL returned');
      }

      await _continueRegistration(
        gender: gender,
        dob: dob,
        address: address,
        bloodType: bloodType,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        allergies: allergies,
        medicalConditions: medicalConditions,
        profileUrl: returnedUrl,
      );
    } on TimeoutException {
      continueRegisterResult = ContinueRegisterResult(
        ContinueRegisterResultStates.isError,
        {'message': 'Request timed out'},
      );
    } catch (e) {
      continueRegisterResult = ContinueRegisterResult(
        ContinueRegisterResultStates.isError,
        {'message': 'Something went wrong: $e'},
      );
    }

    notifyListeners();
  }

  /// Continues registration after image upload
  Future<void> _continueRegistration({
    required String gender,
    required DateTime dob,
    required String address,
    String? bloodType,
    String? emergencyContactName,
    required String emergencyContactPhone,
    required List<String?> allergies,
    required List<String?> medicalConditions,
    required String profileUrl,
  }) async {
    continueRegisterResult = ContinueRegisterResult(
      ContinueRegisterResultStates.isLoading,
      {},
    );
    notifyListeners();

    final continueModel = ContinueRegistrationModel(
      address: address,
      dateOfBirth: dob,
      gender: gender,
      bloodType: bloodType,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      allergies: allergies,
      medicalConditions: medicalConditions,
      profileUrl: profileUrl,
    );
    final response = await _authRepository.continueRegistration(continueModel);
    continueRegisterResult = response;
    notifyListeners();
  }

  /// Clears static flags after fetching user info
  void _resetStaticInfo() {
    _hasFetchedInfo = true;
  }
}
