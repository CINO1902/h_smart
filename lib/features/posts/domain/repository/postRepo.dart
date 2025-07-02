import 'dart:developer';

import '../../../../core/exceptions/network_exception.dart';
import '../../data/repository/post_repo.dart';
import '../../domain/utils/states/postStates.dart';
import '../entities/createComment.dart';
import '../entities/createreplyResponse.dart';
import '../entities/getpostbyId.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<PostResult> getpost({int page = 1, int limit = 10});
  Future<CreateCommentResult> createComment(String postId, String comment);
  Future<CreateReplyResult> createReply(String commentId, String comment);

  Future<CommentResult> getComments(String postId,
      {int commentPage = 1, int commentLimit = 10});

  Future<CommentResult> getReplies(String commentId,
      {int page = 1, int limit = 3});
}

class PostRepositoryImp implements PostRepository {
  final PostDataSource postDataSource;

  PostRepositoryImp(this.postDataSource);

  @override
  Future<PostResult> getpost({int page = 1, int limit = 10}) async {
    PostResult postResult = PostResult(PostResultState.isLoading, GetPost());
    try {
      postResult = await postDataSource.getpost(page: page, limit: limit);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        postResult =
            PostResult(PostResultState.isError, GetPost(message: message));
      } else {
        postResult = PostResult(
            PostResultState.isError, GetPost(message: "Something Went Wrong"));
      }
    }

    return postResult;
  }

  @override
  Future<CommentResult> getComments(String postId,
      {int commentPage = 1, int commentLimit = 10}) async {
    CommentResult commentResult =
        CommentResult(CommentResultState.isLoading, GetPostById());
    try {
      commentResult = await postDataSource.getComments(postId,
          commentPage: commentPage, commentLimit: commentLimit);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        commentResult = CommentResult(
            CommentResultState.isError, GetPostById(message: message));
      } else {
        commentResult = CommentResult(CommentResultState.isError,
            GetPostById(message: "Something Went Wrong"));
      }
    }
    return commentResult;
  }

  @override
  Future<CreateCommentResult> createComment(
      String postId, String comment) async {
    CreateCommentResult createCommentResult = CreateCommentResult(
        CreateCommentResultState.isLoading, CreateComment());
    try {
      createCommentResult = await postDataSource.createComment(postId, comment);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        createCommentResult = CreateCommentResult(
            CreateCommentResultState.isError, CreateComment(message: message));
      } else {
        createCommentResult = CreateCommentResult(
            CreateCommentResultState.isError,
            CreateComment(message: "Something Went Wrong"));
      }
    }
    return createCommentResult;
  }

  @override
  Future<CreateReplyResult> createReply(
      String commentId, String comment) async {
    CreateReplyResult createReplyResult = CreateReplyResult(
        CreateReplyResultState.isLoading, CreateReplyResponse());
    try {
      createReplyResult = await postDataSource.createReply(commentId, comment);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        createReplyResult = CreateReplyResult(CreateReplyResultState.isError,
            CreateReplyResponse(message: message));
      } else {
        createReplyResult = CreateReplyResult(CreateReplyResultState.isError,
            CreateReplyResponse(message: "Something Went Wrong"));
      }
    }
    return createReplyResult;
  }

  @override
  Future<CommentResult> getReplies(String commentId,
      {int page = 1, int limit = 3}) async {
    CommentResult commentResult =
        CommentResult(CommentResultState.isLoading, GetPostById());
    try {
      commentResult =
          await postDataSource.getReplies(commentId, page: page, limit: limit);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        commentResult = CommentResult(
            CommentResultState.isError, GetPostById(message: message));
      } else {
        commentResult = CommentResult(CommentResultState.isError,
            GetPostById(message: "Something Went Wrong"));
      }
    }
    return commentResult;
  }
}
