// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String? message;
    String? accessToken;
    Payload? payload;

    LoginResponse({
        this.message,
        this.accessToken,
        this.payload,
    });

    LoginResponse copyWith({
        String? message,
        String? accessToken,
        Payload? payload,
    }) => 
        LoginResponse(
            message: message ?? this.message,
            accessToken: accessToken ?? this.accessToken,
            payload: payload ?? this.payload,
        );

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json["message"],
        accessToken: json["access_token"],
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "access_token": accessToken,
        "payload": payload?.toJson(),
    };
}

class Payload {
    String? userId;
    String? email;
    bool? isProfileCompleted;

    Payload({
        this.userId,
        this.email,
        this.isProfileCompleted,
    });

    Payload copyWith({
        String? userId,
        String? email,
        bool? isProfileCompleted,
    }) => 
        Payload(
            userId: userId ?? this.userId,
            email: email ?? this.email,
            isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        userId: json["user_id"],
        email: json["email"],
        isProfileCompleted: json["is_profile_completed"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "is_profile_completed": isProfileCompleted,
    };
}
