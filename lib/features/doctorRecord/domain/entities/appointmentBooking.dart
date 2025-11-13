class AppointmentBookingRequest {
  final String doctorsAppointmentsId;
  final String doctorId;
  final String slotBookedStartTime;
  final String slotBookedEndTime;
  final String reason;
  final String type;

  AppointmentBookingRequest({
    required this.doctorsAppointmentsId,
    required this.doctorId,
    required this.slotBookedStartTime,
    required this.slotBookedEndTime,
    required this.reason,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctors_appointments_id': doctorsAppointmentsId,
      'doctor_id': doctorId,
      'slot_booked_start_time': slotBookedStartTime,
      'slot_booked_end_time': slotBookedEndTime,
      'reason': reason,
      'type': type,
    };
  }
}

class AppointmentBookingData {
  final String id;
  final String doctorId;
  final String userId;
  final String reason;
  final String type;
  final String status;
  final String slotBookedStartTime;
  final String slotBookedEndTime;
  final String createdAt;
  final String updatedAt;

  AppointmentBookingData({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.reason,
    required this.type,
    required this.status,
    required this.slotBookedStartTime,
    required this.slotBookedEndTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentBookingData.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingData(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      userId: json['user_id'] ?? '',
      reason: json['reason'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      slotBookedStartTime: json['slot_booked_start_time'] ?? '',
      slotBookedEndTime: json['slot_booked_end_time'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class AppointmentBookingResponse {
  final AppointmentBookingData data;
  final String message;

  AppointmentBookingResponse({
    required this.data,
    required this.message,
  });

  factory AppointmentBookingResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingResponse(
      data: AppointmentBookingData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}