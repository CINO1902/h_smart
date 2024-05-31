// To parse this JSON data, do
//
//     final hospitalModel = hospitalModelFromJson(jsonString);

import 'dart:convert';

HospitalModel hospitalModelFromJson(String str) => HospitalModel.fromJson(json.decode(str));

String hospitalModelToJson(HospitalModel data) => json.encode(data.toJson());

class HospitalModel {
    int count;
    String next;
    dynamic previous;
    List<Result> results;

    HospitalModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory HospitalModel.fromJson(Map<String, dynamic> json) => HospitalModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
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
    String createdAt;
    String updatedAt;

    Result({
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

    factory Result.fromJson(Map<String, dynamic> json) => Result(
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
