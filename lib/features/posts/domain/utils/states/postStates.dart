import '../../entities/post.dart';

class PostResult {
  final PostResultState state;
  final GetPost response;

  PostResult(this.state, this.response);
}

enum PostResultState {
  isLoading,
  isError,
  isData,
  isNull,
  isEmpty,
  networkissue
}
