// To parse this JSON data, do
//
//     final specializeDoctor = specializeDoctorFromJson(jsonString);

import 'dart:convert';

SpecializeDoctor specializeDoctorFromJson(String str) => SpecializeDoctor.fromJson(json.decode(str));

String specializeDoctorToJson(SpecializeDoctor data) => json.encode(data.toJson());

class SpecializeDoctor {
    String status;
    List<Payload> payload;

    SpecializeDoctor({
        required this.status,
        required this.payload,
    });

    factory SpecializeDoctor.fromJson(Map<String, dynamic> json) => SpecializeDoctor(
        status: json["status"],
        payload: List<Payload>.from(json["payload"].map((x) => Payload.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "payload": List<dynamic>.from(payload.map((x) => x.toJson())),
    };
}

class Payload {
    String id;
    List<Doctor> doctors;
    String name;
    String description;
    DateTime createdAt;
    DateTime updatedAt;

    Payload({
        required this.id,
        required this.doctors,
        required this.name,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["id"],
        doctors: List<Doctor>.from(json["doctors"].map((x) => Doctor.fromJson(x))),
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

class Doctor {
    User user;
    String firstName;
    String lastName;
    String phoneNumber;
    String bio;
    String docProfilePicture;

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
