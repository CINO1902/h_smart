import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/doctorRecordController.dart';

final doctorprovider =
    ChangeNotifierProvider((ref) => Doctorprovider(locator()));
