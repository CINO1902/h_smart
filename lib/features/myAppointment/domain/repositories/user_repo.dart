import 'dart:developer';

import 'package:h_smart/features/myAppointment/data/repositories/user_repo.dart';
import 'package:h_smart/features/myAppointment/domain/entities/editProfie.dart';
import 'package:h_smart/features/myAppointment/domain/usecases/appointmentStates.dart';

import '../../../../core/exceptions/network_exception.dart';

abstract class UserRepository {
  Future<UpdateProfileResult> edit_profile(EditProfile editDetails);
}

class UserRepositoryImp implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImp(this.userDataSource);

  @override
  Future<UpdateProfileResult> edit_profile(editDetails) async {
    UpdateProfileResult updateProfileResult = UpdateProfileResult(
      UpdateProfileResultStates.isLoading,
      '',
    );
    try {
      updateProfileResult = await userDataSource.edit_profile(editDetails);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        updateProfileResult =
            UpdateProfileResult(UpdateProfileResultStates.isError, message);
      } else {
        updateProfileResult = UpdateProfileResult(
            UpdateProfileResultStates.isError, "Something Went Wrong");
      }
    }
    return updateProfileResult;
  }
}
