import 'dart:developer';

import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/mydoctor.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/appointmentBooking.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/doctorBooking.dart';
import '../usecases/doctorStates.dart';

abstract class DoctorRepository {
  Future<DoctorBookingResult> getdoctorBookings(String doctorId);
  Future<CallMyDoctorResult> mydoctor();
  Future<AppointmentBookingResult> bookAppointment(AppointmentBookingRequest request);
}

class DoctorRepoImpl implements DoctorRepository {
  final DoctorDatasource doctorDatasource;

  DoctorRepoImpl(this.doctorDatasource);

  @override
  Future<CallMyDoctorResult> mydoctor() async {
    CallMyDoctorResult callMyDoctorResult =
        CallMyDoctorResult(CallMyDoctorResultState.isLoading, Mydoctor());

    try {
      callMyDoctorResult = await doctorDatasource.mydoctor();
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;

        // returnresponse.add('1');
        // returnresponse.add(exp.message);
        callMyDoctorResult = CallMyDoctorResult(CallMyDoctorResultState.isError,
            Mydoctor(message: exp.errorMessage));
      } else {
        callMyDoctorResult = CallMyDoctorResult(CallMyDoctorResultState.isError,
            Mydoctor(message: "Something went wrong"));
      }

      log(e.toString());
    }
    return callMyDoctorResult;
  }

  @override
  Future<DoctorBookingResult> getdoctorBookings(String doctorId) async {
    DoctorBookingResult doctorBookingResult = DoctorBookingResult(
        DoctorBookingResultState.isLoading, DoctorBooking());
    try {
      doctorBookingResult = await doctorDatasource.getdoctorBookings(doctorId);
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;

        doctorBookingResult = DoctorBookingResult(
            DoctorBookingResultState.isError, DoctorBooking(message: message));
      } else {
        doctorBookingResult = DoctorBookingResult(
            DoctorBookingResultState.isError,
            DoctorBooking(message: "something went wrong"));
      }

      log(e.toString());
    }
    return doctorBookingResult;
  }

  @override
  Future<AppointmentBookingResult> bookAppointment(AppointmentBookingRequest request) async {
    AppointmentBookingResult appointmentBookingResult = AppointmentBookingResult(
        AppointmentBookingResultState.isLoading, 
        AppointmentBookingResponse(
          data: AppointmentBookingData(
            id: '', doctorId: '', userId: '', reason: '', type: '', 
            status: '', slotBookedStartTime: '', slotBookedEndTime: '', 
            createdAt: '', updatedAt: ''
          ), 
          message: ''
        ));
    
    try {
      appointmentBookingResult = await doctorDatasource.bookAppointment(request);
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? exp.message;
        
        appointmentBookingResult = AppointmentBookingResult(
            AppointmentBookingResultState.isError, 
            AppointmentBookingResponse(
              data: AppointmentBookingData(
                id: '', doctorId: '', userId: '', reason: '', type: '', 
                status: '', slotBookedStartTime: '', slotBookedEndTime: '', 
                createdAt: '', updatedAt: ''
              ), 
              message: message
            ));
      } else {
        appointmentBookingResult = AppointmentBookingResult(
            AppointmentBookingResultState.isError,
            AppointmentBookingResponse(
              data: AppointmentBookingData(
                id: '', doctorId: '', userId: '', reason: '', type: '', 
                status: '', slotBookedStartTime: '', slotBookedEndTime: '', 
                createdAt: '', updatedAt: ''
              ), 
              message: "Something went wrong"
            ));
      }
      
      log(e.toString());
    }
    return appointmentBookingResult;
  }
}
