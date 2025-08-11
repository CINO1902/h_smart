// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? error;
  String? message;
  LoginPayload? payload;

  LoginResponse({
    this.error,
    this.message,
    this.payload,
  });

  LoginResponse copyWith({
    bool? error,
    String? message,
    LoginPayload? payload,
  }) =>
      LoginResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        payload: payload ?? this.payload,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null
            ? null
            : LoginPayload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
      };
}

class LoginPayload {
  String? accessToken;
  String? email;
  bool? isProfileComplete;
  String? refreshToken;
  String? role;
  String? status;
  String? userId;

  LoginPayload({
    this.accessToken,
    this.email,
    this.isProfileComplete,
    this.refreshToken,
    this.role,
    this.status,
    this.userId,
  });

  LoginPayload copyWith({
    String? accessToken,
    String? email,
    bool? isProfileComplete,
    String? refreshToken,
    String? role,
    String? status,
    String? userId,
  }) =>
      LoginPayload(
        accessToken: accessToken ?? this.accessToken,
        email: email ?? this.email,
        isProfileComplete: isProfileComplete ?? this.isProfileComplete,
        refreshToken: refreshToken ?? this.refreshToken,
        role: role ?? this.role,
        status: status ?? this.status,
        userId: userId ?? this.userId,
      );

  factory LoginPayload.fromJson(Map<String, dynamic> json) => LoginPayload(
        accessToken: json["access_token"],
        email: json["email"],
        isProfileComplete: json["is_profile_complete"],
        refreshToken: json["refresh_token"],
        role: json["role"],
        status: json["status"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "email": email,
        "is_profile_complete": isProfileComplete,
        "refresh_token": refreshToken,
        "role": role,
        "status": status,
        "user_id": userId,
      };
}


