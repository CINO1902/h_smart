// To parse this JSON data, do
//
//     final mydoctor = mydoctorFromJson(jsonString);

import 'dart:convert';

Mydoctor mydoctorFromJson(String str) => Mydoctor.fromJson(json.decode(str));

String mydoctorToJson(Mydoctor data) => json.encode(data.toJson());

class Mydoctor {
  bool isSuccess;
  List<PayloadDoc> payload;

  Mydoctor({
    required this.isSuccess,
    required this.payload,
  });

  factory Mydoctor.fromJson(Map<String, dynamic> json) => Mydoctor(
        isSuccess: json["is_success"],
        payload: List<PayloadDoc>.from(
            json["payload"].map((x) => PayloadDoc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "payload": List<dynamic>.from(payload.map((x) => x.toJson())),
      };
}

class PayloadDoc {
  String id;
  PayloadDoctor doctor;
  String user;

  PayloadDoc({
    required this.id,
    required this.doctor,
    required this.user,
  });

  factory PayloadDoc.fromJson(Map<String, dynamic> json) => PayloadDoc(
        id: json["id"],
        doctor: PayloadDoctor.fromJson(json["doctor"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor": doctor.toJson(),
        "user": user,
      };
}

class PayloadDoctor {
  String id;
  UserDoc user;
  String? docProfilePicture;
  Specialization specialization;
  Hospital hospital;
  String firstName;
  String lastName;
  String phoneNumber;
  String bio;
  DateTime createdAt;
  DateTime updatedAt;

  PayloadDoctor({
    required this.id,
    required this.user,
     this.docProfilePicture,
    required this.specialization,
    required this.hospital,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PayloadDoctor.fromJson(Map<String, dynamic> json) => PayloadDoctor(
        id: json["id"],
        user: UserDoc.fromJson(json["user"]),
        docProfilePicture: json["doc_profile_picture"],
        specialization: Specialization.fromJson(json["specialization"]),
        hospital: Hospital.fromJson(json["hospital"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        bio: json["bio"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "doc_profile_picture": docProfilePicture,
        "specialization": specialization.toJson(),
        "hospital": hospital.toJson(),
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "bio": bio,
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
    required this.coverImage,
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

class Specialization {
  String id;
  List<DoctorElement> doctors;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Specialization({
    required this.id,
    required this.doctors,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
        id: json["id"],
        doctors: List<DoctorElement>.from(
            json["doctors"].map((x) => DoctorElement.fromJson(x))),
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctors": List<dynamic>.from(doctors.map((x) => x.toJson())),
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class DoctorElement {
  UserDoc user;
  String firstName;
  String lastName;
  String phoneNumber;
  String bio;
  String docProfilePicture;

  DoctorElement({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.bio,
    required this.docProfilePicture,
  });

  factory DoctorElement.fromJson(Map<String, dynamic> json) => DoctorElement(
        user: UserDoc.fromJson(json["user"]),
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

class UserDoc {
  String id;
  String email;

  UserDoc({
    required this.id,
    required this.email,
  });

  factory UserDoc.fromJson(Map<String, dynamic> json) => UserDoc(
        id: json["id"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
      };
}
