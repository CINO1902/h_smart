
import 'package:h_smart/core/service/http_service.dart';

import 'package:h_smart/features/myAppointment/data/repositories/user_repo.dart';
import 'package:h_smart/features/myAppointment/domain/entities/editProfie.dart';
import 'package:h_smart/features/myAppointment/domain/usecases/appointmentStates.dart';

import '../../../../constant/enum.dart';

class UserDatasourceImpl implements UserDataSource {
  final HttpService httpService;

  UserDatasourceImpl(this.httpService);

  @override
  Future<UpdateProfileResult> edit_profile(editDetails) async {
    UpdateProfileResult updateProfileResult =
        UpdateProfileResult(UpdateProfileResultStates.isLoading, '');

    final response = await httpService.request(
      url: '/auth/update_patient_profile_metadata',
      methodrequest: RequestMethod.postWithToken,
      data: editProfileToJson(editDetails),
    );

    if (response.statusCode == 200) {
      // final decodedresponse = UserDetails.fromJson(response.data);
      updateProfileResult =
          UpdateProfileResult(UpdateProfileResultStates.isData, '');
    }

    return updateProfileResult;
  }
}
