// To parse this JSON data, do
//
//     final getOverView = getOverViewFromJson(jsonString);

import 'dart:convert';

GetOverView getOverViewFromJson(String str) => GetOverView.fromJson(json.decode(str));

String getOverViewToJson(GetOverView data) => json.encode(data.toJson());

class GetOverView {
    bool? error;
    String? message;
    Payload? payload;

    GetOverView({
        this.error,
        this.message,
        this.payload,
    });

    GetOverView copyWith({
        bool? error,
        String? message,
        Payload? payload,
    }) => 
        GetOverView(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory GetOverView.fromJson(Map<String, dynamic> json) => GetOverView(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class Payload {
    List<Appointment>? appointments;
    String? firstName;
    String? id;
    dynamic imageUrl;
    String? lastName;
    List<Prescription>? prescriptions;

    Payload({
        this.appointments,
        this.firstName,
        this.id,
        this.imageUrl,
        this.lastName,
        this.prescriptions,
    });

    Payload copyWith({
        List<Appointment>? appointments,
        String? firstName,
        String? id,
        dynamic imageUrl,
        String? lastName,
        List<Prescription>? prescriptions,
    }) => 
        Payload(
            appointments: appointments ?? this.appointments,
            firstName: firstName ?? this.firstName,
            id: id ?? this.id,
            imageUrl: imageUrl ?? this.imageUrl,
            lastName: lastName ?? this.lastName,
            prescriptions: prescriptions ?? this.prescriptions,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        appointments: json["appointments"] == null ? [] : List<Appointment>.from(json["appointments"]!.map((x) => Appointment.fromJson(x))),
        firstName: json["first_name"],
        id: json["id"],
        imageUrl: json["image_url"],
        lastName: json["last_name"],
        prescriptions: json["prescriptions"] == null ? [] : List<Prescription>.from(json["prescriptions"]!.map((x) => Prescription.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "appointments": appointments == null ? [] : List<dynamic>.from(appointments!.map((x) => x.toJson())),
        "first_name": firstName,
        "id": id,
        "image_url": imageUrl,
        "last_name": lastName,
        "prescriptions": prescriptions == null ? [] : List<dynamic>.from(prescriptions!.map((x) => x.toJson())),
    };
}

class Appointment {
    DateTime? createdAt;
    DateTime? date;
    String? doctorName;
    String? doctorSpecialization;
    String? id;
    String? status;
    String? time;

    Appointment({
        this.createdAt,
        this.date,
        this.doctorName,
        this.doctorSpecialization,
        this.id,
        this.status,
        this.time,
    });

    Appointment copyWith({
        DateTime? createdAt,
        DateTime? date,
        String? doctorName,
        String? doctorSpecialization,
        String? id,
        String? status,
        String? time,
    }) => 
        Appointment(
            createdAt: createdAt ?? this.createdAt,
            date: date ?? this.date,
            doctorName: doctorName ?? this.doctorName,
            doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
            id: id ?? this.id,
            status: status ?? this.status,
            time: time ?? this.time,
        );

    factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        doctorName: json["doctor_name"],
        doctorSpecialization: json["doctor_specialization"],
        id: json["id"],
        status: json["status"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "date": date?.toIso8601String(),
        "doctor_name": doctorName,
        "doctor_specialization": doctorSpecialization,
        "id": id,
        "status": status,
        "time": time,
    };
}

class Prescription {
    String? dosage;
    String? frequency;
    String? id;
    String? name;

    Prescription({
        this.dosage,
        this.frequency,
        this.id,
        this.name,
    });

    Prescription copyWith({
        String? dosage,
        String? frequency,
        String? id,
        String? name,
    }) => 
        Prescription(
            dosage: dosage ?? this.dosage,
            frequency: frequency ?? this.frequency,
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        dosage: json["dosage"],
        frequency: json["frequency"],
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "dosage": dosage,
        "frequency": frequency,
        "id": id,
        "name": name,
    };
}
