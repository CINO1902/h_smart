
import 'package:h_smart/features/myAppointment/domain/entities/editProfie.dart';
import 'package:h_smart/features/myAppointment/domain/usecases/appointmentStates.dart';

abstract class UserDataSource {
  Future<UpdateProfileResult> edit_profile(
     EditProfile editDetails);
}
