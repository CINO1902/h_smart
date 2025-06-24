import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

import '../../../auth/domain/usecases/authStates.dart';

class HealthProfileScreen extends ConsumerStatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  ConsumerState<HealthProfileScreen> createState() =>
      _HealthProfileScreenState();
}

class _HealthProfileScreenState extends ConsumerState<HealthProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _insuranceNumberController = TextEditingController();
  final _insuranceProviderController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  String? _selectedGender;
  String? _selectedBloodType;
  DateTime? _selectedDateOfBirth;
  List<String> _selectedAllergies = [];
  List<String> _selectedMedicalConditions = [];

  static const List<String> _genderOptions = ['male', 'female', 'other'];
  static const List<String> _bloodTypeOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  static const List<String> _allergyOptions = [
    'Pollen',
    'Dust',
    'Peanuts',
    'Tree Nuts',
    'Milk',
    'Eggs',
    'Soy',
    'Wheat',
    'Fish',
    'Shellfish',
    'Latex',
    'Penicillin',
    'Aspirin',
    'Sulfa Drugs',
    'None'
  ];
  static const List<String> _medicalConditionOptions = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Heart Disease',
    'Arthritis',
    'Depression',
    'Anxiety',
    'Cancer',
    'Stroke',
    'Kidney Disease',
    'Liver Disease',
    'Thyroid Disease',
    'Epilepsy',
    'Migraine',
    'None'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _insuranceNumberController.dispose();
    _insuranceProviderController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authState = ref.read(authProvider);
    final userData = authState.userData?.patientMetadata;

    if (userData != null) {
      setState(() {
        _addressController.text = userData.address ?? '';
        _emergencyNameController.text = userData.emergencyContactName ?? '';
        _emergencyPhoneController.text = userData.emergencyContactPhone ?? '';
        _insuranceNumberController.text =
            userData.insuranceNumber?.toString() ?? '';
        _insuranceProviderController.text =
            userData.insuranceProvider?.toString() ?? '';

        _selectedGender = _normalizeGender(userData.gender);
        _selectedBloodType = _normalizeBloodType(userData.bloodType);
        _selectedDateOfBirth = userData.dateOfBirth;

        // Handle allergies - check if it's a string that needs to be split
        if (userData.allergies != null) {
          if (userData.allergies is List<String>) {
            // Check if the list contains comma-separated strings
            List<String> processedAllergies = [];
            for (String item in userData.allergies!) {
              if (item.contains(',')) {
                // Split comma-separated values
                processedAllergies.addAll(item
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty));
              } else {
                processedAllergies.add(item);
              }
            }
            _selectedAllergies = processedAllergies;
          } else if (userData.allergies is String) {
            _selectedAllergies = (userData.allergies as String)
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          } else {
            _selectedAllergies = [];
          }
        } else {
          _selectedAllergies = [];
        }

        // Handle medical conditions - check if it's a string that needs to be split
        if (userData.medicalConditions != null) {
          if (userData.medicalConditions is List<String>) {
            // Check if the list contains comma-separated strings
            List<String> processedConditions = [];
            for (String item in userData.medicalConditions!) {
              if (item.contains(',')) {
                // Split comma-separated values
                processedConditions.addAll(item
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty));
              } else {
                processedConditions.add(item);
              }
            }
            _selectedMedicalConditions = processedConditions;
          } else if (userData.medicalConditions is String) {
            _selectedMedicalConditions = (userData.medicalConditions as String)
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          } else {
            _selectedMedicalConditions = [];
          }
        } else {
          _selectedMedicalConditions = [];
        }
      });
    }
  }

  String? _normalizeGender(String? gender) {
    if (gender == null) return null;

    // Convert to lowercase and check if it matches our options
    final normalized = gender.toLowerCase();
    if (normalized == 'male') return 'male';
    if (normalized == 'female') return 'female';
    if (normalized == 'other') return 'other';

    // If no match, return null to avoid dropdown error
    return null;
  }

  String? _normalizeBloodType(String? bloodType) {
    if (bloodType == null) return null;

    if (_bloodTypeOptions.contains(bloodType)) {
      return bloodType;
    }

    return null;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateOfBirth == null) {
      SnackBarService.notifyAction(
        context,
        message: 'Please select your date of birth',
        status: SnackbarStatus.fail,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement API call to update health profile

      await ref.read(authProvider).continueRegistration(
            gender: _selectedGender ?? '',
            dob: _selectedDateOfBirth ?? DateTime.now(),
            allergies: _selectedAllergies,
            medicalConditions: _selectedMedicalConditions,
            address: _addressController.text,
            emergencyContactName: _emergencyNameController.text,
            emergencyContactPhone: _emergencyPhoneController.text,
            insuranceProvider: _insuranceProviderController.text,
            insuranceNumber: _insuranceNumberController.text,
          );
      await ref.read(authProvider).fetchUserInfo();
      _loadUserData();

      final authState = ref.read(authProvider);

      if (authState.continueRegisterResult.state ==
          ContinueRegisterResultStates.isData) {
        SnackBarService.showSnackBar(
          context,
          title: 'Success',
          body: 'Health profile updated successfully',
          status: SnackbarStatus.success,
        );
      }
      if (authState.continueRegisterResult.state ==
          ContinueRegisterResultStates.isError) {
        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          body: authState.continueRegisterResult.response['message'],
          status: SnackbarStatus.fail,
        );
      }

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });

        SnackBarService.showSnackBar(
          context,
          title: 'Success',
          body: 'Health profile updated successfully',
          status: SnackbarStatus.success,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          body: 'Failed to update health profile: ${e.toString()}',
          status: SnackbarStatus.fail,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userData = authState.userData?.patientMetadata;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Health Profile',
          style: theme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.iconTheme.color,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: theme.iconTheme.color,
              ),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.blue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.health_and_safety_outlined,
                        color: Colors.green.shade600,
                        size: 24,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            'Keep your health information up to date for better care',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color
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

              // Basic Information Section
              _buildSection(
                title: 'Basic Information',
                children: [
                  _buildDropdownField(
                    label: 'Gender',
                    value: _selectedGender,
                    items: _genderOptions,
                    onChanged: _isEditing
                        ? (value) => setState(() => _selectedGender = value)
                        : null,
                  ),
                  _buildDateField(
                    label: 'Date of Birth',
                    value: _selectedDateOfBirth,
                    onChanged: _isEditing
                        ? (date) => setState(() => _selectedDateOfBirth = date)
                        : null,
                  ),
                  _buildDropdownField(
                    label: 'Blood Type',
                    value: _selectedBloodType,
                    items: _bloodTypeOptions,
                    onChanged: _isEditing
                        ? (value) => setState(() => _selectedBloodType = value)
                        : null,
                  ),
                ],
              ),

              // Contact Information Section
              _buildSection(
                title: 'Contact Information',
                children: [
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    enabled: _isEditing,
                  ),
                  _buildTextField(
                    controller: _emergencyNameController,
                    label: 'Emergency Contact Name',
                    enabled: _isEditing,
                  ),
                  _buildTextField(
                    controller: _emergencyPhoneController,
                    label: 'Emergency Contact Phone',
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),

              // Insurance Information Section
              _buildSection(
                title: 'Insurance Information',
                children: [
                  _buildTextField(
                    controller: _insuranceProviderController,
                    label: 'Insurance Provider',
                    enabled: _isEditing,
                    required: false,
                  ),
                  _buildTextField(
                    controller: _insuranceNumberController,
                    label: 'Insurance Number',
                    enabled: _isEditing,
                    required: false,
                  ),
                ],
              ),

              // Medical Information Section
              _buildSection(
                title: 'Medical Information',
                children: [
                  _buildMultiSelectField(
                    label: 'Allergies',
                    selectedItems: _selectedAllergies,
                    options: _allergyOptions,
                    onChanged: _isEditing
                        ? (items) => setState(() => _selectedAllergies = items)
                        : null,
                  ),
                  _buildMultiSelectField(
                    label: 'Medical Conditions',
                    selectedItems: _selectedMedicalConditions,
                    options: _medicalConditionOptions,
                    onChanged: _isEditing
                        ? (items) =>
                            setState(() => _selectedMedicalConditions = items)
                        : null,
                  ),
                ],
              ),

              // Action Buttons
              if (_isEditing) ...[
                const Gap(32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _loadUserData(); // Reset to original values
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kprimaryColor500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.kprimaryColor500,
          ),
        ),
        const Gap(16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).dividerTheme.color ?? Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: children
                .map((child) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: child,
                    ))
                .toList(),
          ),
        ),
        const Gap(24),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType? keyboardType,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: required
          ? (value) {
              if (value?.trim().isEmpty ?? true) {
                return '$label is required';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: [
        // Add a placeholder item for null values
        if (value == null)
          const DropdownMenuItem<String>(
            value: null,
            child: Text('Select an option'),
          ),
        ...items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?>? onChanged,
  }) {
    return InkWell(
      onTap: onChanged == null
          ? null
          : () async {
              final date = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                onChanged(date);
              }
            },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null
              ? DateFormat('MMM dd, yyyy').format(value)
              : 'Select date',
          style: TextStyle(
            color: value != null ? null : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required List<String> selectedItems,
    required List<String> options,
    required ValueChanged<List<String>>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        if (selectedItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerTheme.color ??
                    Colors.grey.shade300,
              ),
            ),
            child: Text(
              'No items selected',
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedItems.map((item) {
              return Chip(
                label: Text(item),
                backgroundColor: AppColors.kprimaryColor500.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: AppColors.kprimaryColor500,
                  fontWeight: FontWeight.w500,
                ),
                deleteIcon: onChanged != null
                    ? const Icon(Icons.close, size: 18)
                    : null,
                onDeleted: onChanged != null
                    ? () {
                        onChanged(selectedItems
                            .where((selectedItem) => selectedItem != item)
                            .toList());
                      }
                    : null,
              );
            }).toList(),
          ),
        const Gap(12),
        if (onChanged != null) ...[
          Text(
            'Select options:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.7),
            ),
          ),
          const Gap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedItems.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    if (option == 'None') {
                      // If "None" is selected, clear all other selections
                      onChanged([]);
                    } else {
                      // Add the option and remove "None" if it was selected
                      final newSelection = [
                        ...selectedItems.where((item) => item != 'None'),
                        option
                      ];
                      onChanged(newSelection);
                    }
                  } else {
                    // Remove the option
                    onChanged(
                        selectedItems.where((item) => item != option).toList());
                  }
                },
                selectedColor: AppColors.kprimaryColor500.withOpacity(0.2),
                checkmarkColor: AppColors.kprimaryColor500,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.kprimaryColor500
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
