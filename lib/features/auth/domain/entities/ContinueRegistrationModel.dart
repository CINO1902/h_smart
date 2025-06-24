// To parse this JSON data, do
//
//     final continueRegistrationModel = continueRegistrationModelFromJson(jsonString);

import 'dart:convert';

ContinueRegistrationModel continueRegistrationModelFromJson(String str) =>
    ContinueRegistrationModel.fromJson(json.decode(str));

String continueRegistrationModelToJson(ContinueRegistrationModel data) =>
    json.encode(data.toJson());

class ContinueRegistrationModel {
  DateTime dateOfBirth;
  String? gender;
  String? bloodType;
  String? emergencyContactName;
  String? emergencyContactPhone;
  String? address;
  String? insuranceProvider;
  String? insuranceNumber;
  List? allergies;
  List? medicalConditions;
  String? profileUrl;

  ContinueRegistrationModel({
    required this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.address,
    this.insuranceProvider,
    this.insuranceNumber,
    this.allergies,
    this.medicalConditions,
    this.profileUrl,
  });

  ContinueRegistrationModel copyWith({
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? address,
    String? insuranceProvider,
    String? insuranceNumber,
    List? allergies,
    List? medicalConditions,
    String? profileUrl,
  }) =>
      ContinueRegistrationModel(
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        bloodType: bloodType ?? this.bloodType,
        emergencyContactName: emergencyContactName ?? this.emergencyContactName,
        emergencyContactPhone:
            emergencyContactPhone ?? this.emergencyContactPhone,
        address: address ?? this.address,
        insuranceProvider: insuranceProvider ?? this.insuranceProvider,
        insuranceNumber: insuranceNumber ?? this.insuranceNumber,
        allergies: allergies ?? this.allergies,
        medicalConditions: medicalConditions ?? this.medicalConditions,
        profileUrl: profileUrl ?? this.profileUrl,
      );

  factory ContinueRegistrationModel.fromJson(Map<String, dynamic> json) =>
      ContinueRegistrationModel(
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        gender: json["gender"],
        bloodType: json["blood_type"],
        emergencyContactName: json["emergency_contact_name"],
        emergencyContactPhone: json["emergency_contact_phone"],
        address: json["address"],
        insuranceProvider: json["insurance_provider"],
        insuranceNumber: json["insurance_number"],
        allergies: json["allergies"],
        medicalConditions: json["medical_conditions"],
        profileUrl: json["profile_url"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-"
          "${dateOfBirth.month.toString().padLeft(2, '0')}-"
          "${dateOfBirth.day.toString().padLeft(2, '0')}",
      "gender": gender,
      "blood_type": bloodType,
      "emergency_contact_name": emergencyContactName,
      "emergency_contact_phone": emergencyContactPhone,
      "address": address,
      "insurance_provider": insuranceProvider,
      "insurance_number": insuranceNumber,
      "allergies": allergies,
      "medical_conditions": medicalConditions,
      "profile_url": profileUrl,
    };

    // Remove any key whose value is null
    data.removeWhere((key, value) => value == null);

    return data;
  }
}
