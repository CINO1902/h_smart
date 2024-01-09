// To parse this JSON data, do
//
//     final completeProfileRes = completeProfileResFromJson(jsonString);

import 'dart:convert';

CompleteProfileRes completeProfileResFromJson(String str) =>
    CompleteProfileRes.fromJson(json.decode(str));

String completeProfileResToJson(CompleteProfileRes data) =>
    json.encode(data.toJson());

class CompleteProfileRes {
  bool success;
  String message;
  Data data;

  CompleteProfileRes({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompleteProfileRes.fromJson(Map<String, dynamic> json) =>
      CompleteProfileRes(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String user;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String address;
  String contactNumber;
  String profilePicture;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.address,
    required this.contactNumber,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        user: json["user"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        address: json["address"],
        contactNumber: json["contact_number"],
        profilePicture: json["profile_picture"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "address": address,
        "contact_number": contactNumber,
        "profile_picture": profilePicture,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
