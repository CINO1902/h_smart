// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
    bool? error;
    String? message;
    Payload? payload;

    UserDetails({
        this.error,
        this.message,
        this.payload,
    });

    UserDetails copyWith({
        bool? error,
        String? message,
        Payload? payload,
    }) => 
        UserDetails(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class Payload {
    DateTime? createdAt;
    String? email;
    dynamic experienceYears;
    String? firstName;
    String? id;
    String? lastName;
    PatientMetadata? patientMetadata;
    String? phone;
    dynamic qualification;
    dynamic registeredHospital;
    String? role;
    dynamic specialization;
    String? status;
    DateTime? updatedAt;

    Payload({
        this.createdAt,
        this.email,
        this.experienceYears,
        this.firstName,
        this.id,
        this.lastName,
        this.patientMetadata,
        this.phone,
        this.qualification,
        this.registeredHospital,
        this.role,
        this.specialization,
        this.status,
        this.updatedAt,
    });

    Payload copyWith({
        DateTime? createdAt,
        String? email,
        dynamic experienceYears,
        String? firstName,
        String? id,
        String? lastName,
        PatientMetadata? patientMetadata,
        String? phone,
        dynamic qualification,
        dynamic registeredHospital,
        String? role,
        dynamic specialization,
        String? status,
        DateTime? updatedAt,
    }) => 
        Payload(
            createdAt: createdAt ?? this.createdAt,
            email: email ?? this.email,
            experienceYears: experienceYears ?? this.experienceYears,
            firstName: firstName ?? this.firstName,
            id: id ?? this.id,
            lastName: lastName ?? this.lastName,
            patientMetadata: patientMetadata ?? this.patientMetadata,
            phone: phone ?? this.phone,
            qualification: qualification ?? this.qualification,
            registeredHospital: registeredHospital ?? this.registeredHospital,
            role: role ?? this.role,
            specialization: specialization ?? this.specialization,
            status: status ?? this.status,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        email: json["email"],
        experienceYears: json["experience_years"],
        firstName: json["first_name"],
        id: json["id"],
        lastName: json["last_name"],
        patientMetadata: json["patient_metadata"] == null ? null : PatientMetadata.fromJson(json["patient_metadata"]),
        phone: json["phone"],
        qualification: json["qualification"],
        registeredHospital: json["registered_hospital"],
        role: json["role"],
        specialization: json["specialization"],
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "email": email,
        "experience_years": experienceYears,
        "first_name": firstName,
        "id": id,
        "last_name": lastName,
        "patient_metadata": patientMetadata?.toJson(),
        "phone": phone,
        "qualification": qualification,
        "registered_hospital": registeredHospital,
        "role": role,
        "specialization": specialization,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class PatientMetadata {
    String? address;
    List<String>? allergies;
    String? bloodType;
    DateTime? dateOfBirth;
    String? emergencyContactName;
    String? emergencyContactPhone;
    String? gender;
    dynamic insuranceNumber;
    dynamic insuranceProvider;
    bool? isCompleted;
    List<String>? medicalConditions;
    String? profileUrl;

    PatientMetadata({
        this.address,
        this.allergies,
        this.bloodType,
        this.dateOfBirth,
        this.emergencyContactName,
        this.emergencyContactPhone,
        this.gender,
        this.insuranceNumber,
        this.insuranceProvider,
        this.isCompleted,
        this.medicalConditions,
        this.profileUrl,
    });

    PatientMetadata copyWith({
        String? address,
        List<String>? allergies,
        String? bloodType,
        DateTime? dateOfBirth,
        String? emergencyContactName,
        String? emergencyContactPhone,
        String? gender,
        dynamic insuranceNumber,
        dynamic insuranceProvider,
        bool? isCompleted,
        List<String>? medicalConditions,
        String? profileUrl,
    }) => 
        PatientMetadata(
            address: address ?? this.address,
            allergies: allergies ?? this.allergies,
            bloodType: bloodType ?? this.bloodType,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            emergencyContactName: emergencyContactName ?? this.emergencyContactName,
            emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
            gender: gender ?? this.gender,
            insuranceNumber: insuranceNumber ?? this.insuranceNumber,
            insuranceProvider: insuranceProvider ?? this.insuranceProvider,
            isCompleted: isCompleted ?? this.isCompleted,
            medicalConditions: medicalConditions ?? this.medicalConditions,
            profileUrl: profileUrl ?? this.profileUrl,
        );

    factory PatientMetadata.fromJson(Map<String, dynamic> json) => PatientMetadata(
        address: json["address"],
        allergies: json["allergies"] == null ? [] : List<String>.from(json["allergies"]!.map((x) => x)),
        bloodType: json["blood_type"],
        dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
        emergencyContactName: json["emergency_contact_name"],
        emergencyContactPhone: json["emergency_contact_phone"],
        gender: json["gender"],
        insuranceNumber: json["insurance_number"],
        insuranceProvider: json["insurance_provider"],
        isCompleted: json["is_completed"],
        medicalConditions: json["medical_conditions"] == null ? [] : List<String>.from(json["medical_conditions"]!.map((x) => x)),
        profileUrl: json["profile_url"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "allergies": allergies == null ? [] : List<dynamic>.from(allergies!.map((x) => x)),
        "blood_type": bloodType,
        "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "emergency_contact_name": emergencyContactName,
        "emergency_contact_phone": emergencyContactPhone,
        "gender": gender,
        "insurance_number": insuranceNumber,
        "insurance_provider": insuranceProvider,
        "is_completed": isCompleted,
        "medical_conditions": medicalConditions == null ? [] : List<dynamic>.from(medicalConditions!.map((x) => x)),
        "profile_url": profileUrl,
    };
}
