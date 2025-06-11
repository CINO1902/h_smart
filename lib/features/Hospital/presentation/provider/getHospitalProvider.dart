import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/hospitalController.dart';

final hospitalprovider =
    ChangeNotifierProvider((ref) => GetHospitalProvider(locator()));


final expandedSectionProvider = StateProvider<String?>((_) => null);

