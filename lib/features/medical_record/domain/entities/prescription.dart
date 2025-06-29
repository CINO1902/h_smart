// To parse this JSON data, do
//
//     final pescriptionResponse = pescriptionResponseFromJson(jsonString);

import 'dart:convert';

PescriptionResponse pescriptionResponseFromJson(String str) =>
    PescriptionResponse.fromJson(json.decode(str));

String pescriptionResponseToJson(PescriptionResponse data) =>
    json.encode(data.toJson());

class PescriptionResponse {
  bool? error;
  String? message;
  List<Pescription>? payload;

  PescriptionResponse({
    this.error,
    this.message,
    this.payload,
  });

  PescriptionResponse copyWith({
    bool? error,
    String? message,
    List<Pescription>? payload,
  }) =>
      PescriptionResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        payload: payload ?? this.payload,
      );

  factory PescriptionResponse.fromJson(Map<String, dynamic> json) =>
      PescriptionResponse(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null
            ? []
            : List<Pescription>.from(
                json["payload"]!.map((x) => Pescription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload == null
            ? []
            : List<dynamic>.from(payload!.map((x) => x.toJson())),
      };
}

class Pescription {
  DateTime? createdAt;
  String? doctorId;
  String? doctorName;
  String? doctorProfileUrl;
  DateTime? endDate;
  String? id;
  List<Medication>? medications;
  String? patientId;
  String? patientName;
  String? phoneNumber;
  DateTime? startDate;
  String? status;
  DateTime? updatedAt;

  Pescription({
    this.createdAt,
    this.doctorId,
    this.doctorName,
    this.doctorProfileUrl,
    this.endDate,
    this.id,
    this.medications,
    this.patientId,
    this.patientName,
    this.phoneNumber,
    this.startDate,
    this.status,
    this.updatedAt,
  });

  Pescription copyWith({
    DateTime? createdAt,
    String? doctorId,
    String? doctorName,
    String? doctorProfileUrl,
    DateTime? endDate,
    String? id,
    List<Medication>? medications,
    String? patientId,
    String? patientName,
    String? phoneNumber,
    DateTime? startDate,
    String? status,
    DateTime? updatedAt,
  }) =>
      Pescription(
        createdAt: createdAt ?? this.createdAt,
        doctorId: doctorId ?? this.doctorId,
        doctorName: doctorName ?? this.doctorName,
        doctorProfileUrl: doctorProfileUrl ?? this.doctorProfileUrl,
        endDate: endDate ?? this.endDate,
        id: id ?? this.id,
        medications: medications ?? this.medications,
        patientId: patientId ?? this.patientId,
        patientName: patientName ?? this.patientName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        startDate: startDate ?? this.startDate,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Pescription.fromJson(Map<String, dynamic> json) => Pescription(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        doctorProfileUrl: json["doctor_profile_url"],
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        id: json["id"],
        medications: json["medications"] == null
            ? []
            : List<Medication>.from(
                json["medications"]!.map((x) => Medication.fromJson(x))),
        patientId: json["patient_id"],
        patientName: json["patient_name"],
        phoneNumber: json["phone_number"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "doctor_profile_url": doctorProfileUrl,
        "end_date": endDate?.toIso8601String(),
        "id": id,
        "medications": medications == null
            ? []
            : List<dynamic>.from(medications!.map((x) => x.toJson())),
        "patient_id": patientId,
        "patient_name": patientName,
        "phone_number": phoneNumber,
        "start_date": startDate?.toIso8601String(),
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Medication {
  String? dosage;
  String? frequency;
  String? instructions;
  String? name;

  Medication({
    this.dosage,
    this.frequency,
    this.instructions,
    this.name,
  });

  Medication copyWith({
    String? dosage,
    String? frequency,
    String? instructions,
    String? name,
  }) =>
      Medication(
        dosage: dosage ?? this.dosage,
        frequency: frequency ?? this.frequency,
        instructions: instructions ?? this.instructions,
        name: name ?? this.name,
      );

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        dosage: json["dosage"],
        frequency: json["frequency"],
        instructions: json["instructions"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "dosage": dosage,
        "frequency": frequency,
        "instructions": instructions,
        "name": name,
      };
}
