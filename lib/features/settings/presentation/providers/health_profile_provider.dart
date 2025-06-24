import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

enum HealthProfileState {
  idle,
  loading,
  success,
  error,
}

class HealthProfileData {
  final String? gender;
  final String? bloodType;
  final DateTime? dateOfBirth;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? insuranceProvider;
  final String? insuranceNumber;
  final List<String> allergies;
  final List<String> medicalConditions;

  const HealthProfileData({
    this.gender,
    this.bloodType,
    this.dateOfBirth,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.insuranceProvider,
    this.insuranceNumber,
    this.allergies = const [],
    this.medicalConditions = const [],
  });

  HealthProfileData copyWith({
    String? gender,
    String? bloodType,
    DateTime? dateOfBirth,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? insuranceProvider,
    String? insuranceNumber,
    List<String>? allergies,
    List<String>? medicalConditions,
  }) {
    return HealthProfileData(
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
    );
  }
}

class HealthProfileNotifier extends StateNotifier<HealthProfileData> {
  final Ref _ref;

  HealthProfileNotifier(this._ref) : super(const HealthProfileData()) {
    _loadHealthProfile();
  }

  void _loadHealthProfile() {
    final authProviderInstance = _ref.read(authProvider);
    final userData = authProviderInstance.userData?.patientMetadata;
    if (userData != null) {
      state = HealthProfileData(
        gender: userData.gender,
        bloodType: userData.bloodType,
        dateOfBirth: userData.dateOfBirth,
        address: userData.address,
        emergencyContactName: userData.emergencyContactName,
        emergencyContactPhone: userData.emergencyContactPhone,
        insuranceProvider: userData.insuranceProvider?.toString(),
        insuranceNumber: userData.insuranceNumber?.toString(),
        allergies: userData.allergies ?? [],
        medicalConditions: userData.medicalConditions ?? [],
      );
    }
  }

  Future<bool> updateHealthProfile({
    required String gender,
    required DateTime dateOfBirth,
    required String address,
    required String emergencyContactName,
    required String emergencyContactPhone,
    String? bloodType,
    String? insuranceProvider,
    String? insuranceNumber,
    required List<String> allergies,
    required List<String> medicalConditions,
  }) async {
    try {
      // TODO: Implement API call to update health profile
      // This would typically call your backend API to update the patient metadata

      // For now, we'll simulate the API call
      await Future.delayed(const Duration(seconds: 2));

      // Update local state
      state = state.copyWith(
        gender: gender,
        bloodType: bloodType,
        dateOfBirth: dateOfBirth,
        address: address,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        insuranceProvider: insuranceProvider,
        insuranceNumber: insuranceNumber,
        allergies: allergies,
        medicalConditions: medicalConditions,
      );

      // Refresh auth provider data
      final authProviderInstance = _ref.read(authProvider);
      await authProviderInstance.fetchUserInfo();

      return true;
    } catch (e) {
      print('Error updating health profile: $e');
      return false;
    }
  }

  void refreshData() {
    _loadHealthProfile();
  }
}

final healthProfileProvider =
    StateNotifierProvider<HealthProfileNotifier, HealthProfileData>((ref) {
  return HealthProfileNotifier(ref);
});
