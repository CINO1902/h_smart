import 'package:flutter/foundation.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/mydoctor.dart';
import 'package:h_smart/features/doctorRecord/domain/repositories/doctor_repo.dart';
import 'package:h_smart/features/doctorRecord/domain/usecases/doctorStates.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/appointmentBooking.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/doctorBooking.dart';

class Doctorprovider extends ChangeNotifier {
  final DoctorRepository doctorRepository;

  Doctorprovider(this.doctorRepository);

  bool loading = true;
  bool error = false;
  String msg = '';
  bool loadfav = false;
  bool mydocloading = true;
  CallMyDoctorResult callMyDoctorResult =
      CallMyDoctorResult(CallMyDoctorResultState.isLoading, Mydoctor());
  DoctorBookingResult doctorBookingResult =
      DoctorBookingResult(DoctorBookingResultState.isLoading, DoctorBooking());
  AppointmentBookingResult appointmentBookingResult =
      AppointmentBookingResult(AppointmentBookingResultState.idle, 
          AppointmentBookingResponse(
            data: AppointmentBookingData(
              id: '', doctorId: '', userId: '', reason: '', type: '', 
              status: '', slotBookedStartTime: '', slotBookedEndTime: '', 
              createdAt: '', updatedAt: ''
            ), 
            message: ''
          ));
  String favdoctorid = '';
  List<PayloadDoc> mydoctorlist = [];

  Future<void> callmydoctor() async {
    callMyDoctorResult =
        CallMyDoctorResult(CallMyDoctorResultState.isLoading, Mydoctor());
    notifyListeners();
    final response = await doctorRepository.mydoctor();
    callMyDoctorResult = response;
    if (response.state == CallMyDoctorResultState.isData) {
      final doctorid = mydoctorlist[0].doctor.user.id;
      final pref = await SharedPreferences.getInstance();
      pref.setString('favdoctorid', doctorid);
      favdoctorid = doctorid;
    }

    notifyListeners();
  }

  Future<void> getdoctorBookings(String doctorId) async {
    doctorBookingResult = DoctorBookingResult(
        DoctorBookingResultState.isLoading, DoctorBooking());
    notifyListeners();
    final response = await doctorRepository.getdoctorBookings(doctorId);
    doctorBookingResult = response;
    notifyListeners();
  }

  Future<void> bookAppointment(AppointmentBookingRequest request) async {
    appointmentBookingResult = AppointmentBookingResult(
        AppointmentBookingResultState.isLoading, 
        AppointmentBookingResponse(
          data: AppointmentBookingData(
            id: '', doctorId: '', userId: '', reason: '', type: '', 
            status: '', slotBookedStartTime: '', slotBookedEndTime: '', 
            createdAt: '', updatedAt: ''
          ), 
          message: ''
        ));
    notifyListeners();
    
    final response = await doctorRepository.bookAppointment(request);
    appointmentBookingResult = response;
    notifyListeners();
  }
}
