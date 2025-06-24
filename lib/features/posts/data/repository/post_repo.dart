import '../../domain/utils/states/postStates.dart';

abstract class PostDataSource {
  Future<PostResult> getpost({int page = 1, int limit = 10});
}
