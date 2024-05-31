// To parse this JSON data, do
//
//     final prescription = prescriptionFromJson(jsonString);

import 'dart:convert';

Prescription prescriptionFromJson(String str) =>
    Prescription.fromJson(json.decode(str));

String prescriptionToJson(Prescription data) => json.encode(data.toJson());

class Prescription {
  String status;
  List<Datum> data;

  Prescription({
    required this.status,
    required this.data,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  DoctorName doctorName;
  PatientName patientName;
  List<Specializations> drugs;
  DateTime prescriptionDate;
  String description;
  String dosage;
  bool isCurrent;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.drugs,
    required this.prescriptionDate,
    required this.description,
    required this.dosage,
    required this.isCurrent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        doctorName: DoctorName.fromJson(json["doctor_name"]),
        patientName: PatientName.fromJson(json["patient_name"]),
        drugs: List<Specializations>.from(
            json["drugs"].map((x) => Specializations.fromJson(x))),
        prescriptionDate: DateTime.parse(json["prescription_date"]),
        description: json["description"],
        dosage: json["dosage"],
        isCurrent: json["is_current"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_name": doctorName.toJson(),
        "patient_name": patientName.toJson(),
        "drugs": List<dynamic>.from(drugs.map((x) => x.toJson())),
        "prescription_date":
            "${prescriptionDate.year.toString().padLeft(4, '0')}-${prescriptionDate.month.toString().padLeft(2, '0')}-${prescriptionDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "dosage": dosage,
        "is_current": isCurrent,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class DoctorName {
  String id;
  User user;
  Specializations specialization;
  Hospital hospital;
  dynamic docProfilePicture;
  String firstName;
  String lastName;
  String phoneNumber;
  String bio;
  String couldinaryFileField;
  DateTime createdAt;
  DateTime updatedAt;

  DoctorName({
    required this.id,
    required this.user,
    required this.specialization,
    required this.hospital,
    this.docProfilePicture,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.bio,
    required this.couldinaryFileField,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorName.fromJson(Map<String, dynamic> json) => DoctorName(
        id: json["id"],
        user: User.fromJson(json["user"]),
        specialization: Specializations.fromJson(json["specialization"]),
        hospital: Hospital.fromJson(json["hospital"]),
        docProfilePicture: json["doc_profile_picture"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        bio: json["bio"],
        couldinaryFileField: json["couldinary_file_field"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "specialization": specialization.toJson(),
        "hospital": hospital.toJson(),
        "doc_profile_picture": docProfilePicture,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "bio": bio,
        "couldinary_file_field": couldinaryFileField,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Hospital {
  String id;
  String name;
  String address;
  String city;
  String state;
  dynamic coverImage;
  String type;
  String country;
  String phoneNumber;
  String email;
  String website;
  DateTime createdAt;
  DateTime updatedAt;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    this.coverImage,
    required this.type,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        coverImage: json["cover_image"],
        type: json["type"],
        country: json["country"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        website: json["website"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "state": state,
        "cover_image": coverImage,
        "type": type,
        "country": country,
        "phone_number": phoneNumber,
        "email": email,
        "website": website,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Specializations {
  String id;
  List<Doctor>? doctors;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Specializations({
    required this.id,
    this.doctors,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Specializations.fromJson(Map<String, dynamic> json) => Specializations(
        id: json["id"],
        doctors: json["doctors"] == null
            ? []
            : List<Doctor>.from(
                json["doctors"]!.map((x) => Doctor.fromJson(x))),
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctors": doctors == null
            ? []
            : List<dynamic>.from(doctors!.map((x) => x.toJson())),
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Doctor {
  User user;
  String firstName;
  String lastName;
  String phoneNumber;
  String bio;
  dynamic docProfilePicture;

  Doctor({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.bio,
    required this.docProfilePicture,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        user: User.fromJson(json["user"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        bio: json["bio"],
        docProfilePicture: json["doc_profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "bio": bio,
        "doc_profile_picture": docProfilePicture,
      };
}

class User {
  String id;
  String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
      };
}

class PatientName {
  String id;
  String user;
  dynamic profilePicture;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String address;
  String contactNumber;
  String couldinaryFileField;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic hospital;

  PatientName({
    required this.id,
    required this.user,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.address,
    required this.contactNumber,
    required this.couldinaryFileField,
    required this.createdAt,
    required this.updatedAt,
    required this.hospital,
  });

  factory PatientName.fromJson(Map<String, dynamic> json) => PatientName(
        id: json["id"],
        user: json["user"],
        profilePicture: json["profile_picture"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        address: json["address"],
        contactNumber: json["contact_number"],
        couldinaryFileField: json["couldinary_file_field"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        hospital: json["hospital"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "profile_picture": profilePicture,
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "address": address,
        "contact_number": contactNumber,
        "couldinary_file_field": couldinaryFileField,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "hospital": hospital,
      };
}
