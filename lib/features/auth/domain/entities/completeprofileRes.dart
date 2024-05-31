// To parse this JSON data, do
//
//     final completeProfileRes = completeProfileResFromJson(jsonString);

import 'dart:convert';

CompleteProfileRes completeProfileResFromJson(String str) =>
    CompleteProfileRes.fromJson(json.decode(str));

String completeProfileResToJson(CompleteProfileRes data) =>
    json.encode(data.toJson());

class CompleteProfileRes {
  String status;
  List<Data> data;

  CompleteProfileRes({
    required this.status,
    required this.data,
  });

  factory CompleteProfileRes.fromJson(Map<String, dynamic> json) =>
      CompleteProfileRes(
        status: json["status"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
  dynamic couldinaryFileField;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic hospital;

  Data({
    required this.id,
    required this.user,
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        user: json["user"],
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
