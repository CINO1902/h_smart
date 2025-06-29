import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:h_smart/constant/network_api.dart';
import 'package:h_smart/features/auth/domain/entities/ContinueRegistrationModel.dart';
import 'package:h_smart/features/auth/domain/entities/createaccount.dart';
import 'package:h_smart/features/auth/domain/entities/loginResponse.dart'
    hide LoginPayload;
import 'package:h_smart/features/auth/domain/entities/loginmodel.dart';
import 'package:h_smart/features/auth/domain/repositories/authrepo.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:h_smart/features/medical_record/domain/entities/userDetailsModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class responsible for all authentication-related operations,
/// including login, registration, OTP verification, and user profile management.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authRepository) {
    // Call your “on-create” method here:
    init();
  }

  final AuthRepository _authRepository;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    emailLogin = prefs.getString('emailLogin') ?? '';
    // print(emailLogin);
    notifyListeners();
  }

  /// Local state fields
  File? _profileImage;
  bool _isImageLoading = false;
  bool _uploadImageError = false;
  bool _isLoggedOut = false;
  final bool _infoLoading = true;
  bool _hasFetchedInfo = false;
  bool isHomePageInitialized = false;
  String emailLogin = '';

  /// Controllers for image picking and other async tasks
  final ImagePicker _imagePicker = ImagePicker();

  /// Result states for various API calls
  LoginResult loginResult = LoginResult(
    LoginResultStates.isIdle,
    LoginResponse(),
  );

  SendTokenChangePasswordResult sendTokenChangePasswordResult =
      SendTokenChangePasswordResult(
    SendTokenChangePasswordResultStates.isIdle,
    {},
  );

  ChangePasswordResult changePasswordResult =
      ChangePasswordResult(ChangePasswordResultStates.isIdle, {});
  VerifyEmailResult verifyEmailResult = VerifyEmailResult(
    VerifyEmailResultStates.isIdle,
    {},
  );
  GetUserResult getInfoResult = GetUserResult(
    GetUserResultStates.isIdle,
    UserDetails(),
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

  Payload? _userData;

  Payload? get userData => _userData;

  /// Getters for private fields
  File? get profileImage => _profileImage;
  bool get isImageLoading => _isImageLoading;
  bool get uploadImageError => _uploadImageError;
  bool get isLoggedOut => _isLoggedOut;
  bool get infoLoading => _infoLoading;
  bool get hasFetchedInfo => _hasFetchedInfo;

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
      final profileCompleted = response.response.payload?.isProfileComplete;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token ?? '');
      await prefs.setBool('profile_completed', profileCompleted ?? false);
    }
    loginResult = response;
    notifyListeners();
  }

  void markhometarget(value) {
    isHomePageInitialized = value;
    notifyListeners();
  }

  ///Change Password for users
  Future<void> changepassword({
    required String changePasswordToken,
    required String password,
  }) async {
    changePasswordResult =
        ChangePasswordResult(ChangePasswordResultStates.isLoading, {});
    notifyListeners();

    final response =
        await _authRepository.changepassword(changePasswordToken, password);
    _isLoggedOut = false;

    // if (response.state == ChangePasswordResultStates.isData) {
    //   final token = response.response.payload?.accessToken;
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.setString('jwt_token', token ?? '');
    // }
    changePasswordResult = response;
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

  Future<void> sendotpChangePassword({required String email}) async {
    sendTokenChangePasswordResult = SendTokenChangePasswordResult(
      SendTokenChangePasswordResultStates.isLoading,
      {},
    );
    notifyListeners();

    final response = await _authRepository.sendtokenChangePassword(email);
    sendTokenChangePasswordResult = response;
    notifyListeners();
  }

  /// Fetches user info from backend and caches into SharedPreferences
  Future<void> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    getInfoResult = GetUserResult(GetUserResultStates.isLoading, UserDetails());
    notifyListeners();

    final response = await _authRepository.getuserdetails();
    getInfoResult = response;
    if (response.state == GetUserResultStates.loggedOut) {
      _isLoggedOut = true;
      notifyListeners();
    }
    if (response.state == GetUserResultStates.isError) {
      final message = response.response.message ?? '';
      if (message.contains('Given token not valid') ||
          message.contains('User not found')) {
        _isLoggedOut = true;
      }
    } else {
      final dataList = getInfoResult.response.payload;

      // _userData = dataList;
      // ——— SAVE PAYLOAD INTO SharedPreferences ———
      if (dataList != null) {
        // 1. Convert Payload → Map → JSON string
        final payloadMap = dataList.toJson();
        final payloadJsonString = json.encode(payloadMap);

        // 2. Write that string under a key, e.g. "user_payload"
        await prefs.setString('user_payload', payloadJsonString);
        loadSavedPayload();
      }

      //Save Payload here
    }

    notifyListeners();
  }

  void resetLoggedOutUser() {
    _isLoggedOut = false;
    notifyListeners();
  }

  Future<Payload?> loadSavedPayload() async {
    final prefs = await SharedPreferences.getInstance();
    final storedString = prefs.getString('user_payload');
    print(storedString);
    if (storedString == null) return null;

    try {
      final Map<String, dynamic> decoded = json.decode(storedString);
      final restored = Payload.fromJson(decoded);
      _userData = restored;
      notifyListeners();
      return restored;
    } catch (e) {
      // If something went wrong (e.g. JSON is malformed), remove the bad entry:
      await prefs.remove('user_payload');
      return null;
    }
  }

  Future<void> saveEmailLogin(email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailLogin', email);
  }

  Future<void> unSaveEmailLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emailLogin');
  }

  // Future<void> checkSaveEmail() async {
  //   notifyListeners();
  // }

  /// Clears user data on logout
  Future<void> logout() async {
    _hasFetchedInfo = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_payload');
    await prefs.remove('jwt_token');
    markhometarget(false);
    init(); 
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
  Future<void> callActivation({required String email}) async {
    emailVerificationResult = EmailVerificationResult(
      EmailVerificationResultState.isLoading,
      {},
    );
    notifyListeners();

    final response = await _authRepository.callActivationToken(email);
    emailVerificationResult = response;
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
      '$baseImageUrl/upload?privacy_level=public',
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

      await continueRegistration(
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
  Future<void> continueRegistration({
    required String gender,
    required DateTime dob,
    required String address,
    String? bloodType,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? insuranceProvider,
    String? insuranceNumber,
    required List<String?> allergies,
    required List<String?> medicalConditions,
    String? profileUrl,
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
}
