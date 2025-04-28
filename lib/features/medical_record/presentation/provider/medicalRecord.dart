import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/medicalRecordController.dart';

final medicalRecordProvider =
    ChangeNotifierProvider((ref) => MedicalRecordprovider(locator()));
