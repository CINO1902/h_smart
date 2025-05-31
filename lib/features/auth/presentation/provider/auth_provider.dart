import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/auth_controller.dart';

final authProvider =
    ChangeNotifierProvider((ref) => AuthProvider(locator()));
