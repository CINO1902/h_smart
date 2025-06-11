import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';

class DoctorsResponse {
  final List<Doctor>? doctors;
  final String? message;

  DoctorsResponse({
    this.doctors,
    this.message,
  });

  factory DoctorsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorsResponse(
      doctors: json['doctors'] != null
          ? (json['doctors'] as List<dynamic>)
              .map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
              .toList()
          : [],
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctors': doctors?.map((doctor) => doctor.toJson()).toList() ?? [],
      'message': message,
    };
  }

  bool get hasDoctors => doctors?.isNotEmpty ?? false;
  bool get isEmpty => !hasDoctors;
  int get doctorCount => doctors?.length ?? 0;
}
