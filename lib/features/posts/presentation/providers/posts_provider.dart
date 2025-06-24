import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/posts/presentation/controllers/postController.dart';

import '../../../../core/service/locator.dart';

final postsProvider =
    ChangeNotifierProvider((ref) => PostController(locator()));
