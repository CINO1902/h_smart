import '../../entities/createComment.dart';
import '../../entities/createreplyResponse.dart';
import '../../entities/getpostbyId.dart';
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

class CreateCommentResult {
  final CreateCommentResultState state;
  final CreateComment response;

  CreateCommentResult(this.state, this.response);
}

enum CreateCommentResultState {
  isLoading,
  isError,
  isData,
  isNull,
  isEmpty,
  networkissue
}

class CreateReplyResult {
  final CreateReplyResultState state;
  final CreateReplyResponse response;

  CreateReplyResult(this.state, this.response);
}

enum CreateReplyResultState { isLoading, isError, isData, isNull, isEmpty }
class CommentResult {
  final CommentResultState state;
  final GetPostById response;

  CommentResult(this.state, this.response);
}

enum CommentResultState { isLoading, isError, isData, isNull, isEmpty }
