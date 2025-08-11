import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';

class DefaultHospitalResponse {
  final bool error;
  final String message;
  final DefaultHospitalPayload? payload;

  DefaultHospitalResponse({
    required this.error,
    required this.message,
    this.payload,
  });

  factory DefaultHospitalResponse.fromJson(Map<String, dynamic> json) {
    return DefaultHospitalResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      payload: json['payload'] != null
          ? DefaultHospitalPayload.fromJson(json['payload'])
          : null,
    );
  }
}

class DefaultHospitalPayload {
  final List<Hospital> hospitals;
  final DefaultHospitalSummary summary;

  DefaultHospitalPayload({
    required this.hospitals,
    required this.summary,
  });

  factory DefaultHospitalPayload.fromJson(Map<String, dynamic> json) {
    return DefaultHospitalPayload(
      hospitals: (json['hospitals'] as List<dynamic>?)
              ?.map((hospital) => Hospital.fromJson(hospital))
              .toList() ??
          [],
      summary: DefaultHospitalSummary.fromJson(json['summary'] ?? {}),
    );
  }
}

class DefaultHospitalSummary {
  final Hospital? defaultHospital;
  final bool hasDefault;
  final int totalConnected;

  DefaultHospitalSummary({
    this.defaultHospital,
    required this.hasDefault,
    required this.totalConnected,
  });

  factory DefaultHospitalSummary.fromJson(Map<String, dynamic> json) {
    return DefaultHospitalSummary(
      defaultHospital: json['default_hospital'] != null
          ? Hospital.fromJson(json['default_hospital'])
          : null,
      hasDefault: json['has_default'] ?? false,
      totalConnected: json['total_connected'] ?? 0,
    );
  }
}