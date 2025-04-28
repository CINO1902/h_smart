import 'dart:convert';

HospitalModel hospitalModelFromJson(String str) =>
    HospitalModel.fromJson(json.decode(str));

String hospitalModelToJson(HospitalModel data) => json.encode(data.toJson());

class HospitalModel {
  int? count;
  String? msg;
  String? next;
  dynamic previous;
  List<Result>? results;

  HospitalModel({
    this.count,
    this.msg,
    this.next,
    this.previous,
    this.results,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) => HospitalModel(
        count: json["count"],
        msg: json["message"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] != null
            ? List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (count != null) "count": count,
        if (next != null) "next": next,
        if (previous != null) "previous": previous,
        if (results != null)
          "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  String? id;
  String? name;
  String? address;
  String? city;
  String? state;
  dynamic coverImage;
  String? type;
  String? country;
  String? phoneNumber;
  String? email;
  String? website;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.name,
    this.address,
    this.city,
    this.state,
    this.coverImage,
    this.type,
    this.country,
    this.phoneNumber,
    this.email,
    this.website,
    this.createdAt,
    this.updatedAt,
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
        if (id != null) "id": id,
        if (name != null) "name": name,
        if (address != null) "address": address,
        if (city != null) "city": city,
        if (state != null) "state": state,
        if (coverImage != null) "cover_image": coverImage,
        if (type != null) "type": type,
        if (country != null) "country": country,
        if (phoneNumber != null) "phone_number": phoneNumber,
        if (email != null) "email": email,
        if (website != null) "website": website,
        if (createdAt != null) "created_at": createdAt,
        if (updatedAt != null) "updated_at": updatedAt,
      };
}
