import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/chat/presentation/controller/chatservice.dart';

import '../../../../core/service/locator.dart';

final chatProviderController =
    ChangeNotifierProvider((ref) => ChatController(locator()));
