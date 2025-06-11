import 'dart:convert';

CompleteProfile completeProfileFromJson(String str) =>
    CompleteProfile.fromJson(json.decode(str));

String completeProfileToJson(CompleteProfile data) =>
    json.encode(data.toJson());

class CompleteProfile {
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String address;
  String contactNumber;

  CompleteProfile({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.address,
    required this.contactNumber,
  });
  

  factory CompleteProfile.fromJson(Map<String, dynamic> json) =>
      CompleteProfile(
        firstName: json["first_name"],
        lastName: json["last_name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        address: json["address"],
        contactNumber: json["contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "address": address,
        "contact_number": contactNumber,
      };
}
