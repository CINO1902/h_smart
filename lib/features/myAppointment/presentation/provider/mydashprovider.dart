import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/myAppointmentController.dart';

final appointmentProvider =
    ChangeNotifierProvider((ref) => Mydashprovider(locator()));
