// To parse this JSON data, do
//
//     final doctorBooking = doctorBookingFromJson(jsonString);

import 'dart:convert';

DoctorBooking doctorBookingFromJson(String str) => DoctorBooking.fromJson(json.decode(str));

String doctorBookingToJson(DoctorBooking data) => json.encode(data.toJson());

class DoctorBooking {
    List<bookingData>? data;
    String? message;

    DoctorBooking({
        this.data,
        this.message,
    });

    DoctorBooking copyWith({
        List<bookingData>? data,
        String? message,
    }) => 
        DoctorBooking(
            data: data ?? this.data,
            message: message ?? this.message,
        );

    factory DoctorBooking.fromJson(Map<String, dynamic> json) => DoctorBooking(
        data: json["data"] == null ? [] : List<bookingData>.from(json["data"]!.map((x) => bookingData.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class bookingData {
    bool? allowslotbetweenbreak;
    String? dayOfWeek;
    String? doctorName;
    List<String>? endTime;
    String? hospitalId;
    String? hospitalName;
    String? id;
    String? sessionTime;
    List<String>? startTime;
    String? userId;

    bookingData({
        this.allowslotbetweenbreak,
        this.dayOfWeek,
        this.doctorName,
        this.endTime,
        this.hospitalId,
        this.hospitalName,
        this.id,
        this.sessionTime,
        this.startTime,
        this.userId,
    });

    bookingData copyWith({
        bool? allowslotbetweenbreak,
        String? dayOfWeek,
        String? doctorName,
        List<String>? endTime,
        String? hospitalId,
        String? hospitalName,
        String? id,
        String? sessionTime,
        List<String>? startTime,
        String? userId,
    }) => 
        bookingData(
            allowslotbetweenbreak: allowslotbetweenbreak ?? this.allowslotbetweenbreak,
            dayOfWeek: dayOfWeek ?? this.dayOfWeek,
            doctorName: doctorName ?? this.doctorName,
            endTime: endTime ?? this.endTime,
            hospitalId: hospitalId ?? this.hospitalId,
            hospitalName: hospitalName ?? this.hospitalName,
            id: id ?? this.id,
            sessionTime: sessionTime ?? this.sessionTime,
            startTime: startTime ?? this.startTime,
            userId: userId ?? this.userId,
        );

    factory bookingData.fromJson(Map<String, dynamic> json) => bookingData(
        allowslotbetweenbreak: json["allowslotbetweenbreak"],
        dayOfWeek: json["day_of_week"],
        doctorName: json["doctor_name"],
        endTime: json["end_time"] == null ? [] : List<String>.from(json["end_time"]!.map((x) => x)),
        hospitalId: json["hospital_id"],
        hospitalName: json["hospital_name"],
        id: json["id"],
        sessionTime: json["session_time"],
        startTime: json["start_time"] == null ? [] : List<String>.from(json["start_time"]!.map((x) => x)),
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "allowslotbetweenbreak": allowslotbetweenbreak,
        "day_of_week": dayOfWeek,
        "doctor_name": doctorName,
        "end_time": endTime == null ? [] : List<dynamic>.from(endTime!.map((x) => x)),
        "hospital_id": hospitalId,
        "hospital_name": hospitalName,
        "id": id,
        "session_time": sessionTime,
        "start_time": startTime == null ? [] : List<dynamic>.from(startTime!.map((x) => x)),
        "user_id": userId,
    };
}
