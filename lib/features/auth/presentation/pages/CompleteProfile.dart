import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/presentation/widget/index.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'package:h_smart/constant/utils.dart';
import 'package:h_smart/constant/snackbar.dart'
    show SnackBarService, SnackbarStatus;
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/theme_mode_provider.dart';
import 'CompleteProfileWidget/EnhanceMultiSelect.dart';
import 'CompleteProfileWidget/EnhancedDropDown.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _dateChosen = false;
  PhoneNumber _phoneNumber =
      PhoneNumber(countryISOCode: '', countryCode: '', number: '');
  String? _selectedGender;
  String? _selectedBloodType;
  List<String> _selectedAllergies = [];
  List<String> _selectedConditions = [];

  bool _showValidationErrors = false;

  static const _genders = ['male', 'female', 'other'];
  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  static const _allergyOptions = [
    'Pollen',
    'Dust',
    'Peanuts',
    'Seafood',
    'Gluten'
  ];
  static const _conditionOptions = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Heart Disease',
    'None'
  ];

  List<Map<String, dynamic>> _addressPredictions = [];
  bool _isLoadingPredictions = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dobController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();

    super.dispose();
  }

  Future<void> _pickDate() async {
    if (Platform.isIOS) {
      Utils.showSheet(
        context,
        child: SizedBox(
          height: 210,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumYear: 1950,
            maximumYear: DateTime.now().year,
            onDateTimeChanged: (d) => _selectedDate = d,
          ),
        ),
        onClicked: () {
          _setDate(_selectedDate);
          Navigator.pop(context);
        },
      );
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      );
      if (picked != null) _setDate(picked);
    }
  }

  void _setDate(DateTime date) {
    _selectedDate = date;
    _dobController.text = DateFormat('yyyy-MM-dd').format(date);
    setState(() => _dateChosen = true);
  }

  Future<void> _onContinue() async {
    setState(() {
      _showValidationErrors = true;
    });
    print(_selectedAllergies);
    final auth = ref.read(authProvider);
    if (auth.continueRegisterResult.state ==
        ContinueRegisterResultStates.isLoading) {
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_phoneController.text.trim().isEmpty) {
      SnackBarService.notifyAction(
        context,
        message: 'Phone number is required',
        status: SnackbarStatus.fail,
      );
      return;
    }
    if (!_dateChosen) {
      SnackBarService.notifyAction(
        context,
        message: 'Date of birth is required',
        status: SnackbarStatus.fail,
      );
      return;
    }
    if (_selectedGender == null) {
      SnackBarService.notifyAction(
        context,
        message: 'Gender is required',
        status: SnackbarStatus.fail,
      );
      return;
    }
    if (_selectedBloodType == null) {
      SnackBarService.notifyAction(
        context,
        message: 'Blood type is required',
        status: SnackbarStatus.fail,
      );
      return;
    }
    if (auth.profileImage == null) {
      SnackBarService.notifyAction(
        context,
        message: 'Please insert a picture',
        status: SnackbarStatus.fail,
      );
      return;
    }
    try {
      SmartDialog.showLoading();

      await auth.uploadProfile(
        gender: _selectedGender!,
        dob: DateTime.parse(_dobController.text),
        address: _addressController.text.trim(),
        bloodType: _selectedBloodType,
        emergencyContactName: _emergencyNameController.text.trim(),
        emergencyContactPhone: _phoneNumber.completeNumber,
        allergies: _selectedAllergies,
        medicalConditions: _selectedConditions,
      );
      SmartDialog.dismiss();

      final result = ref.watch(authProvider).continueRegisterResult;
      final message = result.response['message'] ?? '';
      if (result.state == ContinueRegisterResultStates.isError) {
        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          body: message,
          status: SnackbarStatus.fail,
        );
      } else if (result.state == ContinueRegisterResultStates.isData) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('profile_completed', true);
        SnackBarService.showSnackBar(
          context,
          title: 'Success',
          body: message,
          status: SnackbarStatus.success,
        );
        ref.read(authProvider).clearProfileImage();
        context.go('/profile-complete');
      } else if (result.state == ContinueRegisterResultStates.islogout) {
        ref.read(authProvider).logout();
        context.go('/login');
        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          body: message,
          status: SnackbarStatus.fail,
        );
      }
    } catch (e) {
      SnackBarService.notifyAction(
        context,
        message: 'Error uploading profile $e',
        status: SnackbarStatus.fail,
      );
    }
  }

  Future<void> _getAddressPredictions(String input) async {
    if (input.isEmpty) {
      setState(() => _addressPredictions = []);
      return;
    }
    setState(() => _isLoadingPredictions = true);
    final apiKey = dotenv.env['Places-APi'];
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$apiKey&types=address&components=country:ng',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _addressPredictions =
            List<Map<String, dynamic>>.from(data['predictions'] ?? []);
        _isLoadingPredictions = false;
      });
    } else {
      setState(() {
        _addressPredictions = [];
        _isLoadingPredictions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Complete Your Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: FocusScope(
        autofocus: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Dismiss keyboard when tapping anywhere on the screen
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(16),

                          // Header Section
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.kprimaryColor500.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    AppColors.kprimaryColor500.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.kprimaryColor500,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person_add_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Complete Your Profile',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.kprimaryColor500,
                                            ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        'Make sure your information matches your medical records',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withOpacity(0.7),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Gap(32),

                          // Avatar Section
                          _buildAvatarPicker(context, auth, ref),

                          const Gap(32),

                          // Form Section
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Gap(16),

                                // Date of Birth Field
                                _buildEnhancedDateField(),
                                const Gap(16),

                                // Address Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AuthTextField(
                                      controller: _addressController,
                                      label: 'Address',
                                      hint: 'Enter your full address',
                                      prefixIcon: const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.kprimaryColor500,
                                      ),
                                      onChanged: _getAddressPredictions,
                                      validator: (value) =>
                                          (value == null || value.isEmpty)
                                              ? 'Address is required'
                                              : null,
                                    ),
                                    if (_addressPredictions.isNotEmpty)
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _addressPredictions.length,
                                          itemBuilder: (context, index) {
                                            final prediction =
                                                _addressPredictions[index];
                                            return ListTile(
                                              title: Text(
                                                  prediction['description'] ??
                                                      ''),
                                              onTap: () {
                                                _addressController.text =
                                                    prediction['description'] ??
                                                        '';
                                                setState(() =>
                                                    _addressPredictions = []);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),

                                const Gap(24),

                                Text(
                                  'Emergency Contact',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Gap(16),

                                // Emergency Contact Name Field
                                AuthTextField(
                                  controller: _emergencyNameController,
                                  label: 'Emergency Contact Name',
                                  hint: 'Enter emergency contact\'s full name',
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: AppColors.kprimaryColor500,
                                  ),
                                  validator: (value) =>
                                      (value == null || value.isEmpty)
                                          ? 'Emergency contact name is required'
                                          : null,
                                ),
                                const Gap(10),

                                // Phone Number Field
                                AuthPhoneField(
                                  controller: _phoneController,
                                  label: 'Phone Number',
                                  onChanged: (number) {
                                    setState(() {
                                      _phoneNumber = number;
                                    });
                                  },
                                  hint: 'Enter your phone number',
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                      value == null || !value.isValidNumber()
                                          ? 'Enter a valid phone number'
                                          : null,
                                ),

                                const Gap(24),

                                Text(
                                  'Medical Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Gap(16),

                                // Gender and Blood Type in a row
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EnhancedDropdown(
                                      label: 'Gender *',
                                      value: _selectedGender,
                                      items: _genders,
                                      onChanged: (val) =>
                                          setState(() => _selectedGender = val),
                                    ),
                                    if (_showValidationErrors &&
                                        _selectedGender == null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 4),
                                        child: Text(
                                          'Gender is required',
                                          style: TextStyle(
                                            color: Colors.red[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const Gap(16),
                                    EnhancedDropdown(
                                      label: 'Blood Type *',
                                      value: _selectedBloodType,
                                      items: _bloodTypes,
                                      onChanged: (val) => setState(
                                          () => _selectedBloodType = val),
                                    ),
                                    if (_showValidationErrors &&
                                        _selectedBloodType == null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 4),
                                        child: Text(
                                          'Blood type is required',
                                          style: TextStyle(
                                            color: Colors.red[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const Gap(16),

                                // Multi-select fields
                                EnhancedMultiSelect(
                                  label: 'Allergies',
                                  options: _allergyOptions,
                                  selected: _selectedAllergies,
                                  onConfirm: (vals) => setState(() =>
                                      _selectedAllergies = vals.cast<String>()),
                                ),
                                const Gap(16),

                                EnhancedMultiSelect(
                                  label: 'Medical Conditions',
                                  options: _conditionOptions,
                                  selected: _selectedConditions,
                                  onConfirm: (vals) => setState(() =>
                                      _selectedConditions =
                                          vals.cast<String>()),
                                ),

                                const Gap(40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Continue Button
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: _onContinue,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kprimaryColor500,
                              AppColors.kprimaryColor500.withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.kprimaryColor500.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Complete Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(
      BuildContext context, AuthProvider auth, WidgetRef ref) {
    final isDarkMode = ref.read(themeModeCheckerProvider)(context);
    return Center(
      child: GestureDetector(
        onTap: () => ref.read(authProvider).pickImage(),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kprimaryColor500.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor:
                    isDarkMode ? Colors.grey[700] : Colors.grey[200],
                backgroundImage: auth.profileImage != null
                    ? FileImage(auth.profileImage!)
                    : const AssetImage('images/User.png') as ImageProvider,
                child: auth.isImageLoading
                    ? const CircularProgressIndicator()
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor500,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kprimaryColor500.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDateField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          hintText: 'Select your date of birth',
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: AppColors.kprimaryColor500,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        onTap: _pickDate,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Date of birth is required'
            : null,
      ),
    );
  }
}
