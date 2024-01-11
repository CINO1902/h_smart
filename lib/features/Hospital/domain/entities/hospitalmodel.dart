// To parse this JSON data, do
//
//     final hospitalModel = hospitalModelFromJson(jsonString);

import 'dart:convert';

HospitalModel hospitalModelFromJson(String str) =>
    HospitalModel.fromJson(json.decode(str));

String hospitalModelToJson(HospitalModel data) => json.encode(data.toJson());

class HospitalModel {
  String status;
  int total;
  List<HospitalsDetail> hospitalsDetail;

  HospitalModel({
    required this.status,
    required this.total,
    required this.hospitalsDetail,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) => HospitalModel(
        status: json["status"],
        total: json["total"],
        hospitalsDetail: List<HospitalsDetail>.from(
            json["Hospitals_Detail"].map((x) => HospitalsDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total": total,
        "Hospitals_Detail":
            List<dynamic>.from(hospitalsDetail.map((x) => x.toJson())),
      };
}

class HospitalsDetail {
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
  String? website;
  DateTime createdAt;
  DateTime updatedAt;

  HospitalsDetail({
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
    this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HospitalsDetail.fromJson(Map<String, dynamic> json) =>
      HospitalsDetail(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        coverImage: json["cover_image"],
        type: json["type"]!,
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
