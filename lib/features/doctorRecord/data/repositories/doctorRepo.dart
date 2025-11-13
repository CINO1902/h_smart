import '../../domain/usecases/doctorStates.dart';
import '../../domain/entities/appointmentBooking.dart';

abstract class DoctorDatasource {
  Future<DoctorBookingResult> getdoctorBookings(String doctorId);
  Future<CallMyDoctorResult> mydoctor();
  Future<AppointmentBookingResult> bookAppointment(AppointmentBookingRequest request);
}
