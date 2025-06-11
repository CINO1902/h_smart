// To parse this JSON data, do
//
//     final editProfile = editProfileFromJson(jsonString);

import 'dart:convert';

EditProfile editProfileFromJson(String str) =>
    EditProfile.fromJson(json.decode(str));

String editProfileToJson(EditProfile data) => json.encode(data.toJson());

class EditProfile {
  String? firstName;
  String? lastName;
  String? phone;
  DateTime? dateOfBirth;
  String? address;
  String? profileUrl;

  EditProfile({
    this.firstName,
    this.lastName,
    this.phone,
    this.dateOfBirth,
    this.address,
    this.profileUrl,
  });

  EditProfile copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? dateOfBirth,
    String? address,
    String? profileUrl,
  }) =>
      EditProfile(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        address: address ?? this.address,
        profileUrl: profileUrl ?? this.profileUrl,
      );

  factory EditProfile.fromJson(Map<String, dynamic> json) => EditProfile(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        address: json["address"],
        profileUrl: json["profile_url"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (firstName != null) {
      data["first_name"] = firstName;
    }
    if (lastName != null) {
      data["last_name"] = lastName;
    }
    if (phone != null) {
      data["phone"] = phone;
    }
    if (dateOfBirth != null) {
      // Format as YYYY-MM-DD
      final dob = dateOfBirth!;
      data["date_of_birth"] =
          "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
    }
    if (address != null) {
      data["address"] = address;
    }
    if (profileUrl != null) {
      data["profile_url"] = profileUrl;
    }

    return data;
  }
}
