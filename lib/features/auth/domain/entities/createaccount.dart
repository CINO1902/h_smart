// To parse this JSON data, do
//
//     final registermodel = registermodelFromJson(jsonString);

import 'dart:convert';

Registermodel registermodelFromJson(String str) =>
    Registermodel.fromJson(json.decode(str));

String registermodelToJson(Registermodel data) => json.encode(data.toJson());

class Registermodel {
  String firstname;
  String lastname;
  String email;
  String password;
  String phoneNumber;

  Registermodel(
      {required this.email,
      required this.password,
      required this.firstname,
      required this.lastname,
      required this.phoneNumber});

  factory Registermodel.fromJson(Map<String, dynamic> json) => Registermodel(
        email: json["email"],
        password: json["password"],
        firstname: '',
        lastname: '',
        phoneNumber: '',
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "first_name": firstname,
        "last_name": lastname,
        "phone": phoneNumber
      };
}
