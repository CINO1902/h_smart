import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:h_smart/constant/utils.dart';
import 'package:h_smart/constant/snackbar.dart'
    show SnackBarService, SnackbarStatus;
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:intl/intl.dart';

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

  // FocusNodes
  late FocusNode _dobFocusNode;
  late FocusNode _addressFocusNode;
  late FocusNode _emergencyNameFocusNode;
  late FocusNode _phoneFocusNode;

  DateTime _selectedDate = DateTime.now();
  bool _dateChosen = false;
  late PhoneNumber _phoneNumber;
  String? _selectedGender;
  String? _selectedBloodType;
  List<String> _selectedAllergies = [];
  List<String> _selectedConditions = [];

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

  @override
  void initState() {
    super.initState();
    _dobFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _emergencyNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _dobController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();

    // Dispose focus nodes
    _dobFocusNode.dispose();
    _addressFocusNode.dispose();
    _emergencyNameFocusNode.dispose();
    _phoneFocusNode.dispose();
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
    print(_selectedAllergies);
    final auth = ref.read(authProvider);
    if (auth.continueRegisterResult.state ==
        ContinueRegisterResultStates.isLoading) {
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (!_dateChosen) {
      SnackBarService.notifyAction(
        context,
        message: 'Date of birth is required',
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
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: message,
        status: SnackbarStatus.success,
      );
      context.go('/profile-complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.kprimaryColor500),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Gap(8),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Make sure your name and date of birth matches your medical information',
                  ),
                  const Gap(16),
                  _buildAvatarPicker(context, auth, ref),
                  const Gap(24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // ─── Date of Birth Field ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: _dobController,
                            focusNode: _dobFocusNode,
                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              hintText: 'YYYY-MM-DD',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            onTap: _pickDate,
                            // When user taps “Next” on keyboard, jump to address field
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_addressFocusNode);
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Date of birth is required'
                                    : null,
                          ),
                        ),

                        // ─── Address Field ───────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: _addressController,
                            focusNode: _addressFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: 'Enter your address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_emergencyNameFocusNode);
                            },
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? 'Address can\'t be empty'
                                    : null,
                          ),
                        ),

                        // ─── Emergency Contact Name Field ───────────────────────
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: _emergencyNameController,
                            focusNode: _emergencyNameFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Emergency Contact Name',
                              hintText: 'Enter your emergency contact\'s name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode);
                            },
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? 'Emergency Contact Name can\'t be empty'
                                    : null,
                          ),
                        ),

                        // ─── Phone Number Field ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: IntlPhoneField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            initialCountryCode: 'NG',
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (phone) => _phoneNumber = phone,
                            // When the user hits “done” on keyboard, you might want to close the keyboard:
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                            validator: (value) =>
                                value == null || !value.isValidNumber()
                                    ? 'Enter a valid phone number'
                                    : null,
                          ),
                        ),

                        // ─── Gender / Blood Type / Multi-selects ─────────────────
                        _buildDropdown(
                          label: 'Gender',
                          value: _selectedGender,
                          items: _genders,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                        ),
                        _buildDropdown(
                          label: 'Blood Type',
                          value: _selectedBloodType,
                          items: _bloodTypes,
                          onChanged: (val) =>
                              setState(() => _selectedBloodType = val),
                        ),
                        _buildMultiSelect(
                          label: 'Allergies',
                          options: _allergyOptions,
                          selected: _selectedAllergies,
                          onConfirm: (vals) => setState(
                              () => _selectedAllergies = vals.cast<String>()),
                        ),
                        _buildMultiSelect(
                          label: 'Medical Conditions',
                          options: _conditionOptions,
                          selected: _selectedConditions,
                          onConfirm: (vals) => setState(
                              () => _selectedConditions = vals.cast<String>()),
                        ),

                        const Gap(80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Continue button…
            SafeArea(
              child: GestureDetector(
                onTap: _onContinue,
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.kprimaryColor500,
                  ),
                  child: const Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntlPhoneField(
        initialCountryCode: 'NG',
        controller: _phoneController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (phone) => _phoneNumber = phone,
        validator: (value) => value == null || !value.isValidNumber()
            ? 'Enter a valid phone number'
            : null,
      ),
    );
  }

  Widget _buildAvatarPicker(
      BuildContext context, AuthProvider auth, WidgetRef ref) {
    return Center(
      child: GestureDetector(
        onTap: () => ref.read(authProvider).pickImage(),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: auth.profileImage != null
                  ? FileImage(auth.profileImage!)
                  : const AssetImage('images/User.png') as ImageProvider,
              child: auth.isImageLoading
                  ? const CircularProgressIndicator()
                  : null,
            ),
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.kprimaryColor500,
              child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          hintText: 'YYYY-MM-DD',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: _pickDate,
        validator: (value) => (value == null || value.isEmpty)
            ? 'Date of birth is required'
            : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label'.toLowerCase(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => (value == null || value.trim().isEmpty)
            ? '$label can\'t be empty'
            : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          final selectedValue = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            builder: (ctx) {
              final screenHeight = MediaQuery.of(ctx).size.height;

              // Estimate height based on number of items (roughly 56 px per ListTile)
              final estimatedHeight = 120 + (items.length * 56);
              final minHeight = screenHeight * 0.2;
              final maxHeight = screenHeight * 0.5;
              final modalHeight =
                  estimatedHeight.clamp(minHeight, maxHeight).toDouble();

              return SizedBox(
                height: modalHeight,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Select $label',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () => Navigator.pop(ctx, item),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );

          if (selectedValue != null) {
            onChanged(selectedValue);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            value ?? 'Select $label',
            style: TextStyle(
              color: value == null ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelect({
    required String label,
    required List<String> options,
    required List<String> selected,
    required Function(List<String?>) onConfirm,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MultiSelectBottomSheetField<String?>(
        selectedColor: AppColors.kprimaryColor500,
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.5,
        listType: MultiSelectListType.LIST,
        items: options.map((e) => MultiSelectItem(e, e)).toList(),
        title: Text(label),
        buttonText: Text(label),
        initialValue: selected,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),

        // Wrap the callback to accept List<String?> and filter out nulls:
        onConfirm: (List<String?> values) {
          final nonNull = values.whereType<String>().toList();
          onConfirm(nonNull);
        },

        chipDisplay: MultiSelectChipDisplay(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          chipColor: Colors.grey.shade200,
          textStyle: const TextStyle(color: Colors.black),
          onTap: (val) {
            setState(() {
              selected.remove(val);
            });
          },
        ),
      ),
    );
  }
}
