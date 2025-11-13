import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/myAppointment/domain/usecases/appointmentStates.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:h_smart/constant/Inkbutton.dart';
import 'package:h_smart/constant/customesnackbar.dart';
import 'package:h_smart/features/myAppointment/presentation/provider/mydashprovider.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

import '../../../../core/theme/theme_mode_provider.dart';

class PersonalInfo extends ConsumerStatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  ConsumerState<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  bool _isEditing = false;
  PhoneNumber? _phoneNumber;

  // Store original values to track changes
  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalAddress = '';
  String _originalPhone = '';
  File? _originalImage;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty strings; actual values will be set after provider read
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();

    // Add listeners to detect changes
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _addressController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));

    // After first frame, read existing user data and split phone number
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      final userData = authState.userData;
      if (userData != null) {
        // Populate text fields
        _firstNameController.text = userData.firstName ?? '';
        _lastNameController.text = userData.lastName ?? '';
        _emailController.text = userData.email ?? '';
        _addressController.text = userData.patientMetadata?.address ?? '';

        // Use appointmentProvider to split and store numeric phone part
        final rawPhone = userData.phone ?? '';
        ref.read(appointmentProvider).splitNumberPureDart(rawPhone);

        // Read the split phone into our local controller
        final splitPhone = ref.read(appointmentProvider).phoneNumber;
        _phoneController.text = splitPhone;

        // Store original values
        _originalFirstName = userData.firstName ?? '';
        _originalLastName = userData.lastName ?? '';
        _originalAddress = userData.patientMetadata?.address ?? '';
        _originalPhone = splitPhone;
        _originalImage = null; // No original image file
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    final uploadProv = ref.read(appointmentProvider);

    // Check if image has changed
    if (uploadProv.image != _originalImage) {
      return true;
    }

    // Check if any text field has changed
    return _firstNameController.text.trim() != _originalFirstName ||
        _lastNameController.text.trim() != _originalLastName ||
        _addressController.text.trim() != _originalAddress ||
        _phoneController.text.trim() != _originalPhone;
  }

  Future<void> _saveChanges() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) return;

    final uploadProv = ref.read(appointmentProvider);
    if (uploadProv.updateProfileResult.state ==
        UpdateProfileResultStates.isLoading) {
      return;
    }

    // 1) Upload image if changed
    if (uploadProv.image != null) {
      SmartDialog.showLoading(msg: 'Updating Image...');
      await uploadProv.uploadimage();
      SmartDialog.dismiss();
      if (uploadProv.uploadImageResult.state ==
          UploadImageResultStates.isError) {
        SmartDialog.dismiss();
        SnackBarService.showSnackBar(context,
            status: SnackbarStatus.fail,
            title: 'Error',
            body: 'There was an issue uploading the image.');
        return;
      }
    }

    // 2) Commit profile edits
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    SmartDialog.showLoading(msg: 'Updating Profile...');
    await uploadProv.editprofile(
      firstName,
      lastName,
      phone,
      address,
    );
    await ref.read(authProvider).fetchUserInfo();
    await ref.read(authProvider).loadSavedPayload();
    SmartDialog.dismiss();

    if (uploadProv.updateProfileResult.state ==
        UpdateProfileResultStates.isError) {
      SnackBarService.showSnackBar(context,
          status: SnackbarStatus.fail,
          title: 'Error',
          body: 'There was an issue updating the image.');
    } else {
      SnackBarService.showSnackBar(context,
          status: SnackbarStatus.success,
          title: 'Error',
          body: 'Profile has been updated successfully');
      setState(() {
        _isEditing = false;

        final authState = ref.read(authProvider);
        final userData = authState.userData;
        final splitPhone = ref.read(appointmentProvider).phoneNumber;
        _originalFirstName = userData?.firstName ?? '';
        print(_originalFirstName);
        _originalLastName = userData?.lastName ?? '';
        _originalAddress = userData?.patientMetadata?.address ?? '';
        _originalPhone = splitPhone;
        _originalImage = null; // No original image file
      });
      // Optionally refresh auth provider data here:
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userData = authState.userData;
    final uploadProv = ref.watch(appointmentProvider);
    final theme = Theme.of(context);
    final profileUrl = userData?.patientMetadata?.profileUrl;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        actions: [
          if (!_isEditing)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () => setState(() => _isEditing = true),
                child: const Icon(Icons.edit_outlined),
              ),
            ),
        ],
        title: const Text(
          'Personal Info',
          style: TextStyle(fontSize: 19),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEDED),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: uploadProv.image != null
                        ? Image.file(
                            uploadProv.image!,
                            fit: BoxFit.cover,
                          )
                        : (profileUrl != null && profileUrl.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: profileUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.error),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      onTap: uploadProv.pickimageupdate,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ref.read(themeModeCheckerProvider)(context)
                    ? theme.colorScheme.surface
                    : const Color(0xFFF3F7FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name
                    Text('First Name',
                        style: TextStyle(
                          color: theme.colorScheme.onBackground,
                        )),
                    const Gap(5),
                    TextFormField(
                      controller: _firstNameController,
                      readOnly: !_isEditing,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ref.read(themeModeCheckerProvider)(context)
                            ? _isEditing
                                ? Colors.black
                                : const Color.fromARGB(255, 48, 48, 48)
                            : _isEditing
                                ? Colors.white
                                : const Color(0xFFEAECF0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (_isEditing &&
                            (value == null || value.trim().isEmpty)) {
                          return 'First name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const Gap(10),

                    // Last Name
                    const Text('Last Name'),
                    const Gap(5),
                    TextFormField(
                      controller: _lastNameController,
                      readOnly: !_isEditing,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ref.read(themeModeCheckerProvider)(context)
                            ? _isEditing
                                ? Colors.black
                                : const Color.fromARGB(255, 48, 48, 48)
                            : _isEditing
                                ? Colors.white
                                : const Color(0xFFEAECF0),
                        contentPadding: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (_isEditing &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Last name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const Gap(10),

                    // Phone Number
                    const Text('Phone Number'),
                    const Gap(5),
                    IntlPhoneField(
                      initialCountryCode: 'NG',
                      controller: _phoneController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ref.read(themeModeCheckerProvider)(context)
                            ? _isEditing
                                ? Colors.black
                                : const Color.fromARGB(255, 48, 48, 48)
                            : _isEditing
                                ? Colors.white
                                : const Color(0xFFEAECF0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged:
                          _isEditing ? (number) => _phoneNumber = number : null,
                      validator: (value) {
                        if (_isEditing) {
                          if (value == null || !value.isValidNumber()) {
                            return 'Enter a valid phone number';
                          }
                        }
                        return null;
                      },
                    ),
                    const Gap(10),

                    // Address
                    const Text('Address'),
                    const Gap(5),
                    TextFormField(
                      controller: _addressController,
                      readOnly: !_isEditing,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ref.read(themeModeCheckerProvider)(context)
                            ? _isEditing
                                ? Colors.black
                                : const Color.fromARGB(255, 48, 48, 48)
                            : _isEditing
                                ? Colors.white
                                : const Color(0xFFEAECF0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (_isEditing &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Address cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const Gap(10),

                    // Email (always read-only)
                    const Text('Email'),
                    const Gap(5),
                    TextFormField(
                      controller: _emailController,
                      readOnly: true,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ref.read(themeModeCheckerProvider)(context)
                            ? _isEditing
                                ? Colors.black
                                : const Color.fromARGB(255, 48, 48, 48)
                            : _isEditing
                                ? Colors.white
                                : const Color(0xFFEAECF0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(50),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                child: InkWell(
                  onTap: _hasChanges()
                      ? _saveChanges
                      : () => SnackBarService.notifyAction(
                            context,
                            message: 'You haven\'t made any change',
                            status: SnackbarStatus.fail,
                          ),
                  child: InkButton(
                    title: 'Update Changes',
                    active: !_hasChanges(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
