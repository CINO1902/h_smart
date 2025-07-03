import 'package:h_smart/features/posts/domain/entities/moreReplytoreply.dart';

import '../../entities/createComment.dart';
import '../../entities/createreplyResponse.dart';
import '../../entities/getpostbyId.dart';
import '../../entities/post.dart';
import '../../entities/replyModel.dart';
import '../../entities/replytoreplyResponse.dart';

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

class ReplyResult {
  final ReplyResultState state;
  final ReplyModel response;

  ReplyResult(this.state, this.response);
}

enum ReplyResultState { isLoading, isError, isData, isNull, isEmpty }

class NestedReplyResult {
  final NestedReplyResultState state;
  final MoreReplyToReplyModel response;

  NestedReplyResult(this.state, this.response);
}

enum NestedReplyResultState { isLoading, isError, isData, isNull, isEmpty }

class CreateReplytoReplyResult {
  final CreateReplytoReplyState state;
  final ReplyToReplyModel response;

  CreateReplytoReplyResult(this.state, this.response);
}

enum CreateReplytoReplyState { isLoading, isError, isData, isNull, isEmpty }
