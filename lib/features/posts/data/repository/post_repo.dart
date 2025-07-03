import '../../domain/utils/states/postStates.dart';

abstract class PostDataSource {
  Future<PostResult> getpost({int page = 1, int limit = 10});
  Future<CommentResult> getComments(String postId,
      {int commentPage = 1, int commentLimit = 10});
  Future<CreateCommentResult> createComment(String postId, String comment);
  Future<CreateReplyResult> createReply(String commentId, String comment);
  Future<CreateReplytoReplyResult> createReplyToReply(String replyId, String comment, String commentId);
  Future<ReplyResult> getReplies(String commentId,
      {int page = 1, int limit = 3});
  Future<NestedReplyResult> getNestedReplies(String replyId,
      {int page = 1, int limit = 3});
}
