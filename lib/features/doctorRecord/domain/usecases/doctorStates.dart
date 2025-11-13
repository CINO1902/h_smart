import '../entities/doctorBooking.dart';
import '../entities/mydoctor.dart';
import '../entities/appointmentBooking.dart';

class CallMyDoctorResult {
  final CallMyDoctorResultState state;
  final Mydoctor response;

  CallMyDoctorResult(this.state, this.response);
}

enum CallMyDoctorResultState { isLoading, isError, isData, idle }

class DoctorBookingResult {
  final DoctorBookingResultState state;
  final DoctorBooking response;

  DoctorBookingResult(this.state, this.response);
}

enum DoctorBookingResultState { isLoading, isError, isData, idle }

class AppointmentBookingResult {
  final AppointmentBookingResultState state;
  final AppointmentBookingResponse response;

  AppointmentBookingResult(this.state, this.response);
}

enum AppointmentBookingResultState { isLoading, isError, isData, idle }
