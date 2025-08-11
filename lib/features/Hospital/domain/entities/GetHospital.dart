// To parse this JSON data, do
//
//     final getHospital = getHospitalFromJson(jsonString);

import 'dart:convert';

GetHospital getHospitalFromJson(String str) =>
    GetHospital.fromJson(json.decode(str));

String getHospitalToJson(GetHospital data) => json.encode(data.toJson());

class GetHospital {
  bool? error;
  String? message;
  Payload? payload;

  GetHospital({
    this.error,
    this.message,
    this.payload,
  });

  GetHospital copyWith({
    bool? error,
    String? message,
    Payload? payload,
  }) =>
      GetHospital(
        error: error ?? this.error,
        message: message ?? this.message,
        payload: payload ?? this.payload,
      );

  factory GetHospital.fromJson(Map<String, dynamic> json) => GetHospital(
        error: json["error"],
        message: json["message"],
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
      };
}

class Payload {
  List<Hospital>? hospitals;
  Pagination? pagination;

  Payload({
    this.hospitals,
    this.pagination,
  });

  Payload copyWith({
    List<Hospital>? hospitals,
    Pagination? pagination,
  }) =>
      Payload(
        hospitals: hospitals ?? this.hospitals,
        pagination: pagination ?? this.pagination,
      );

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        hospitals: json["hospitals"] == null
            ? []
            : List<Hospital>.from(
                json["hospitals"]!.map((x) => Hospital.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "hospitals": hospitals == null
            ? []
            : List<dynamic>.from(hospitals!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Hospital {
  String? adminEmail;
  String? adminFirstName;
  String? adminLastName;
  String? adminPhone;
  String? city;
  String? country;
  DateTime? createdAt;
  String? email;
  List<String>? facilities;
  String? hospitalName;
  String? hospitalsCoverImage;
  int? icuBeds;
  String? id;
  bool? isConnected;
  String? licenseNumber;
  String? logo;
  int? operationTheaters;
  String? ownershiptype;
  String? phone;
  String? registrationNumber;
  String? state;
  String? status;
  String? street;
  int? totalBeds;
  DateTime? updatedAt;
  String? zipcode;

  Hospital({
    this.adminEmail,
    this.adminFirstName,
    this.adminLastName,
    this.adminPhone,
    this.city,
    this.country,
    this.createdAt,
    this.email,
    this.facilities,
    this.hospitalName,
    this.hospitalsCoverImage,
    this.icuBeds,
    this.id,
    this.isConnected,
    this.licenseNumber,
    this.logo,
    this.operationTheaters,
    this.ownershiptype,
    this.phone,
    this.registrationNumber,
    this.state,
    this.status,
    this.street,
    this.totalBeds,
    this.updatedAt,
    this.zipcode,
  });

  Hospital copyWith({
    String? adminEmail,
    String? adminFirstName,
    String? adminLastName,
    String? adminPhone,
    String? city,
    String? country,
    DateTime? createdAt,
    String? email,
    List<String>? facilities,
    String? hospitalName,
    String? hospitalsCoverImage,
    int? icuBeds,
    String? id,
    bool? isConnected,
    String? licenseNumber,
    String? logo,
    int? operationTheaters,
    String? ownershiptype,
    String? phone,
    String? registrationNumber,
    String? state,
    String? status,
    String? street,
    int? totalBeds,
    DateTime? updatedAt,
    String? zipcode,
  }) =>
      Hospital(
        adminEmail: adminEmail ?? this.adminEmail,
        adminFirstName: adminFirstName ?? this.adminFirstName,
        adminLastName: adminLastName ?? this.adminLastName,
        adminPhone: adminPhone ?? this.adminPhone,
        city: city ?? this.city,
        country: country ?? this.country,
        createdAt: createdAt ?? this.createdAt,
        email: email ?? this.email,
        facilities: facilities ?? this.facilities,
        hospitalName: hospitalName ?? this.hospitalName,
        hospitalsCoverImage: hospitalsCoverImage ?? this.hospitalsCoverImage,
        icuBeds: icuBeds ?? this.icuBeds,
        id: id ?? this.id,
        isConnected: isConnected ?? this.isConnected,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        logo: logo ?? this.logo,
        operationTheaters: operationTheaters ?? this.operationTheaters,
        ownershiptype: ownershiptype ?? this.ownershiptype,
        phone: phone ?? this.phone,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        state: state ?? this.state,
        status: status ?? this.status,
        street: street ?? this.street,
        totalBeds: totalBeds ?? this.totalBeds,
        updatedAt: updatedAt ?? this.updatedAt,
        zipcode: zipcode ?? this.zipcode,
      );

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        adminEmail: json["admin_email"],
        adminFirstName: json["admin_first_name"],
        adminLastName: json["admin_last_name"],
        adminPhone: json["admin_phone"],
        city: json["city"],
        country: json["country"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        email: json["email"],
        facilities: json["facilities"] == null
            ? []
            : List<String>.from(json["facilities"]!.map((x) => x)),
        hospitalName: json["hospital_name"],
        hospitalsCoverImage: json["hospitals_cover_image"],
        icuBeds: json["icu_beds"],
        id: json["id"],
        isConnected: json["is_connected"],
        licenseNumber: json["license_number"],
        logo: json["logo"],
        operationTheaters: json["operation_theaters"],
        ownershiptype: json["ownershiptype"],
        phone: json["phone"],
        registrationNumber: json["registration_number"],
        state: json["state"],
        status: json["status"],
        street: json["street"],
        totalBeds: json["total_beds"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        zipcode: json["zipcode"],
      );

  Map<String, dynamic> toJson() => {
        "admin_email": adminEmail,
        "admin_first_name": adminFirstName,
        "admin_last_name": adminLastName,
        "admin_phone": adminPhone,
        "city": city,
        "country": country,
        "created_at": createdAt?.toIso8601String(),
        "email": email,
        "facilities": facilities == null
            ? []
            : List<dynamic>.from(facilities!.map((x) => x)),
        "hospital_name": hospitalName,
        "hospitals_cover_image": hospitalsCoverImage,
        "icu_beds": icuBeds,
        "id": id,
        "is_connected": isConnected,
        "license_number": licenseNumber,
        "logo": logo,
        "operation_theaters": operationTheaters,
        "ownershiptype": ownershiptype,
        "phone": phone,
        "registration_number": registrationNumber,
        "state": state,
        "status": status,
        "street": street,
        "total_beds": totalBeds,
        "updated_at": updatedAt?.toIso8601String(),
        "zipcode": zipcode,
      };
}

class Pagination {
  int? connectedCount;
  int? currentPage;
  int? notConnectedCount;
  int? perPage;
  int? totalCount;
  int? totalPages;

  Pagination({
    this.connectedCount,
    this.currentPage,
    this.notConnectedCount,
    this.perPage,
    this.totalCount,
    this.totalPages,
  });

  Pagination copyWith({
    int? connectedCount,
    int? currentPage,
    int? notConnectedCount,
    int? perPage,
    int? totalCount,
    int? totalPages,
  }) =>
      Pagination(
        connectedCount: connectedCount ?? this.connectedCount,
        currentPage: currentPage ?? this.currentPage,
        notConnectedCount: notConnectedCount ?? this.notConnectedCount,
        perPage: perPage ?? this.perPage,
        totalCount: totalCount ?? this.totalCount,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        connectedCount: json["connected_count"],
        currentPage: json["current_page"],
        notConnectedCount: json["not_connected_count"],
        perPage: json["per_page"],
        totalCount: json["total_count"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "connected_count": connectedCount,
        "current_page": currentPage,
        "not_connected_count": notConnectedCount,
        "per_page": perPage,
        "total_count": totalCount,
        "total_pages": totalPages,
      };
}
