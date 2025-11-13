import 'package:h_smart/features/doctorRecord/data/repositories/doctorRepo.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/doctorBooking.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/appointmentBooking.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/mydoctor.dart';
import '../../domain/usecases/doctorStates.dart';

class DoctorDatasourceImp implements DoctorDatasource {
  final HttpService httpService;
  DoctorDatasourceImp(this.httpService);

  @override
  Future<CallMyDoctorResult> mydoctor() async {
    CallMyDoctorResult callMyDoctorResult =
        CallMyDoctorResult(CallMyDoctorResultState.isLoading, Mydoctor());

    final response = await httpService.request(
      url: '/my/doctor/',
      methodrequest: RequestMethod.getWithToken,
    );

    if (response.statusCode == 200) {
      // result = '2';

      // returnvalue.add(result);
      // returnvalue.add(response.data);
      final decodedresponse = mydoctorFromJson(response.data);
      callMyDoctorResult =
          CallMyDoctorResult(CallMyDoctorResultState.isData, decodedresponse);
    }

    return callMyDoctorResult;
  }

  @override
  Future<DoctorBookingResult> getdoctorBookings(String doctorId) async {
    DoctorBookingResult doctorBookingResult = DoctorBookingResult(
        DoctorBookingResultState.isLoading, DoctorBooking());
    final response = await httpService.request(
      url: '/doctor-appointments/user/$doctorId',
      methodrequest: RequestMethod.getWithToken,
    );
    print(response.data);
    if (response.statusCode == 200) {
      final decodedresponse = DoctorBooking.fromJson(response.data);
      doctorBookingResult =
          DoctorBookingResult(DoctorBookingResultState.isData, decodedresponse);
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
    
    final response = await httpService.request(
      url: '/doctor-bookings',
      methodrequest: RequestMethod.postWithToken,
      data: request.toJson(),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedresponse = AppointmentBookingResponse.fromJson(response.data);
      appointmentBookingResult = AppointmentBookingResult(
          AppointmentBookingResultState.isData, decodedresponse);
    } else {
      appointmentBookingResult = AppointmentBookingResult(
          AppointmentBookingResultState.isError, 
          AppointmentBookingResponse(
            data: AppointmentBookingData(
              id: '', doctorId: '', userId: '', reason: '', type: '', 
              status: '', slotBookedStartTime: '', slotBookedEndTime: '', 
              createdAt: '', updatedAt: ''
            ), 
            message: response.data['message'] ?? 'Failed to book appointment'
          ));
    }
    
    return appointmentBookingResult;
  }
}
