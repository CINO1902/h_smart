import 'package:flutter/material.dart';
import 'package:h_smart/features/posts/domain/entities/getpostbyId.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart'
    as postentities;
import 'package:h_smart/features/posts/domain/entities/replytoreplyResponse.dart';
import 'package:h_smart/features/posts/domain/repository/postRepo.dart';
import 'package:h_smart/features/posts/domain/utils/states/postStates.dart';

import '../../domain/entities/createComment.dart';
import '../../domain/entities/createreplyResponse.dart';
import '../../domain/entities/getpostbyId.dart' as getpostbyid;
import 'package:h_smart/features/posts/domain/entities/moreReplytoreply.dart'
    as more_reply_to_reply;

class PostController extends ChangeNotifier {
  final PostRepository postRepository;

  PostController(this.postRepository) {
    if (postResult.state != PostResultState.isLoading ||
        postResult.state != PostResultState.isData) {
      getpost();
    }
  }

  PostResult postResult =
      PostResult(PostResultState.isLoading, postentities.GetPost());
  CommentResult commentResult =
      CommentResult(CommentResultState.isLoading, getpostbyid.GetPostById());
  CreateCommentResult createCommentResult =
      CreateCommentResult(CreateCommentResultState.isNull, CreateComment());
  CreateReplyResult createReplyResult =
      CreateReplyResult(CreateReplyResultState.isNull, CreateReplyResponse());
  CreateReplytoReplyResult createReplyToReplyResult = CreateReplytoReplyResult(
      CreateReplytoReplyState.isNull, ReplyToReplyModel());
  List<dynamic> _allPosts = [];
  int _currentPage = 1;
  int _limit = 10;

  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  int _commentsPage = 1;
  final int _commentsLimit = 5;
  bool _hasMoreComments = true;
  bool _isLoadingMoreComments = false;
  List<getpostbyid.Comment> _allComments = [];

  // Reply pagination state per comment
  final Map<String, int> _replyPage = {};
  final Map<String, bool> _hasMoreReplies = {};
  final Map<String, bool> _isLoadingMoreReplies = {};
  final int _replyLimit = 3;

  // Nested reply pagination state per reply
  final Map<String, int> _nestedReplyPage = {};
  final Map<String, bool> _hasMoreNestedReplies = {};
  final Map<String, bool> _isLoadingMoreNestedReplies = {};
  final int _nestedReplyLimit = 3;

  final Map<String, NestedReplyResult> _nestedReplyResults = {};
  Map<String, NestedReplyResult> get nestedReplyResults => _nestedReplyResults;

  List<dynamic> get allPosts => _allPosts;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;
  List<getpostbyid.Comment> get allComments => _allComments;
  bool get hasMoreComments => _hasMoreComments;
  bool get isLoadingMoreComments => _isLoadingMoreComments;
  bool hasMoreRepliesForComment(String commentId) =>
      _hasMoreReplies[commentId] ?? false;
  bool isLoadingMoreRepliesForComment(String commentId) =>
      _isLoadingMoreReplies[commentId] ?? false;
  bool hasMoreNestedRepliesForReply(String replyId) =>
      _hasMoreNestedReplies[replyId] ?? false;
  bool isLoadingMoreNestedRepliesForReply(String replyId) =>
      _isLoadingMoreNestedReplies[replyId] ?? false;

  Future<void> getpost() async {
    _currentPage = 1;
    _allPosts = [];
    _hasMoreData = true;

    postResult = PostResult(PostResultState.isLoading, postentities.GetPost());
    notifyListeners();

    try {
      final result =
          await postRepository.getpost(page: _currentPage, limit: _limit);

      if (result.state == PostResultState.isData) {
        final newPosts = result.response.payload ?? [];
        _allPosts = newPosts;
        _hasMoreData = newPosts.length >= _limit;
        postResult = result;
      } else {
        postResult = result;
      }
    } catch (e) {
      print('Error loading posts: $e');
      postResult = PostResult(PostResultState.isError,
          postentities.GetPost(message: "Failed to load posts"));
    }

    notifyListeners();
  }

  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final result =
          await postRepository.getpost(page: nextPage, limit: _limit);

      if (result.state == PostResultState.isData) {
        final newPosts = result.response.payload ?? [];
        if (newPosts.isNotEmpty) {
          _allPosts.addAll(newPosts);
          _currentPage = nextPage;
          _hasMoreData = newPosts.length >= _limit;
        } else {
          _hasMoreData = false;
        }
      }
    } catch (e) {
      // Handle error silently for load more
      print('Error loading more posts: $e');
    }

    _isLoadingMore = false;       
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    getpost();
  }
  


  Future<void> getComments(String postId, {int page = 1, int? limit}) async {
      

    if (page == 1) {
      commentResult = CommentResult(
          CommentResultState.isLoading, getpostbyid.GetPostById());
      _allComments = [];
      _hasMoreComments = true;
      _commentsPage = 1;
    }
    notifyListeners();
    final result = await postRepository.getComments(postId,
        commentPage: page, commentLimit: limit ?? _commentsLimit);
    if (result.state == CommentResultState.isData) {
      final commentsObj = result.response.payload?.comments;
      final newComments = commentsObj?.comments ?? [];
      final totalCount = result.response.payload?.commentsCount ?? 0;
      if (page == 1) {
        _allComments = newComments;
      } else {
        _allComments.addAll(newComments);
      }
      // Update the payload's comments so UI using commentResult still works
      result.response.payload?.comments = getpostbyid.Comments(
          comments: _allComments,
          commentsCount: totalCount,
          totalCount: totalCount);
      commentResult = result;
      _hasMoreComments = _allComments.length < totalCount;
      // Set up _hasMoreReplies for each comment based on replies.totalCount
      for (final comment in _allComments) {
        final totalReplies = comment.replies?.totalCount ?? 0;
        print(totalReplies);
        _hasMoreReplies[comment.id ?? ''] = totalReplies > 1;
      }
      _commentsPage = page;
    }
    notifyListeners();
  }

  Future<void> loadMoreComments(String postId) async {
    if (_isLoadingMoreComments || !_hasMoreComments) return;
    _isLoadingMoreComments = true;
    notifyListeners();
    final nextPage = _commentsPage + 1;
    final result = await postRepository.getComments(postId,
        commentPage: nextPage, commentLimit: _commentsLimit);
    if (result.state == CommentResultState.isData) {
      final commentsObj = result.response.payload?.comments;
      final newComments = commentsObj?.comments ?? [];
      final totalCount = result.response.payload?.commentsCount ?? 0;
      _allComments.addAll(newComments);
      // Update the payload's comments so UI using commentResult still works
      commentResult.response.payload?.comments = getpostbyid.Comments(
          comments: _allComments,
          commentsCount: totalCount,
          totalCount: totalCount);
      _hasMoreComments = _allComments.length < totalCount;
      _commentsPage = nextPage;
      for (final comment in _allComments) {
        final totalReplies = comment.replies?.totalCount ?? 0;
        print(totalReplies);
        _hasMoreReplies[comment.id ?? ''] = totalReplies > 1;
      }
    }
    _isLoadingMoreComments = false;
    notifyListeners();
  }

  Future<void> createComment(String postId, String comment) async {
    createCommentResult = CreateCommentResult(
        CreateCommentResultState.isLoading, CreateComment());
    notifyListeners();
    try {
      final result = await postRepository.createComment(postId, comment);
      if (result.state == CreateCommentResultState.isData &&
          result.response.payload != null) {
        final newCommentPayload = result.response.payload!;
        final newComment = getpostbyid.Comment(
          id: newCommentPayload.id,
          comment: newCommentPayload.comment,
          createdAt: newCommentPayload.createdAt,
          postId: newCommentPayload.postId,
          replies: newCommentPayload.replies,
          updatedAt: newCommentPayload.updatedAt,
          userId: newCommentPayload.userId,
          userImage: newCommentPayload.userImage,
          userName: newCommentPayload.userName,
        );
        // Add the new comment to the beginning of the existing list
        commentResult.response.payload?.comments?.comments
            ?.insert(0, newComment);
      }
      createCommentResult = result;
    } catch (e) {
      createCommentResult = CreateCommentResult(
          CreateCommentResultState.isError,
          CreateComment(message: 'Failed to create comment'));
    }
    notifyListeners();
  }

  Future<void> createReply(String commentId, String comment) async {
    createReplyResult = CreateReplyResult(
        CreateReplyResultState.isLoading, CreateReplyResponse());
    notifyListeners();
    try {
      final result = await postRepository.createReply(commentId, comment);
      if (result.state == CreateReplyResultState.isData &&
          result.response.payload != null) {
        final newReplyPayload = result.response.payload!;
        final newReply = getpostbyid.Reply(
          commentId: commentId,
          createdAt: newReplyPayload.createdAt,
          id: newReplyPayload.id,
          repliesToReplies: null, // Adjust if you support replies to replies
          reply:
              newReplyPayload.comment, // 'comment' in payload is the reply text
          updatedAt: newReplyPayload.updatedAt,
          userId: newReplyPayload.userId,
          userImage: newReplyPayload.userImage,
          userName: newReplyPayload.userName,
        );

        // Find the comment and insert the reply at the beginning
        final comments = commentResult.response.payload?.comments?.comments;
        if (comments != null) {
          getpostbyid.Comment? targetComment;
          for (final c in comments) {
            if (c.id == commentId) {
              targetComment = c;
              break;
            }
          }
          if (targetComment != null) {
            targetComment.replies ??= getpostbyid.Repliesreplies(
                replies: [], repliesCount: 0, totalCount: 0);
            targetComment.replies!.replies ??= [];
            targetComment.replies!.replies!.insert(0, newReply);
          }
        }
      }
      createReplyResult = result;
    } catch (e) {
      createReplyResult = CreateReplyResult(CreateReplyResultState.isError,
          CreateReplyResponse(message: 'Failed to create reply'));
    }
    notifyListeners();
  }

  Future<void> createReplyToReply(
      String replyId, String comment, String commentId) async {
    createReplyToReplyResult = CreateReplytoReplyResult(
        CreateReplytoReplyState.isLoading, ReplyToReplyModel());
    notifyListeners();
    try {
      final result =
          await postRepository.createReplyToReply(replyId, comment, commentId);
      if (result.state == CreateReplytoReplyState.isData &&
          result.response.payload != null) {
        final newNestedReplyPayload = result.response.payload!;
        final newNestedReply = getpostbyid.Reply(
          commentId: replyId, // This will be the parent reply ID
          createdAt: DateTime.now(),
          id: newNestedReplyPayload.id,
          repliesToReplies: null,
          reply: newNestedReplyPayload.reply,
          updatedAt: DateTime.now(),
          userId: newNestedReplyPayload.userId,
          userImage: newNestedReplyPayload.userImage,
          userName: newNestedReplyPayload.userName,
        );

        // Find the parent reply and insert the nested reply at the beginning
        final comments = commentResult.response.payload?.comments?.comments;
        if (comments != null) {
          for (final comment in comments) {
            final replies = comment.replies?.replies;
            if (replies != null) {
              for (final reply in replies) {
                if (reply.id == replyId) {
                  reply.repliesToReplies ??= getpostbyid.Repliesreplies(
                      replies: [], repliesCount: 0, totalCount: 0);
                  reply.repliesToReplies!.replies ??= [];
                  reply.repliesToReplies!.replies!.insert(0, newNestedReply);
                  break;
                }
              }
            }
          }
        }
      }
      createReplyToReplyResult = result;
    } catch (e) {
      createReplyToReplyResult = CreateReplytoReplyResult(
          CreateReplytoReplyState.isError,
          ReplyToReplyModel(message: 'Failed to create reply to reply'));
    }
    notifyListeners();
  }

  Future<void> loadMoreReplies(String commentId) async {
    if (_isLoadingMoreReplies[commentId] == true) return;
    _isLoadingMoreReplies[commentId] = true;
    notifyListeners();

    // Find the comment
    final comments = commentResult.response.payload?.comments?.comments;
    final comment = comments?.firstWhere((c) => c.id == commentId,
        orElse: () => getpostbyid.Comment());
    if (comment == null) {
      _isLoadingMoreReplies[commentId] = false;
      notifyListeners();
      return;
    }

    int currentPage = _replyPage[commentId] ?? 1;
    // int nextPage = currentPage;

    // Fetch more replies (assume postRepository.getReplies exists, or will add)
    try {
      final result = await postRepository.getReplies(commentId,
          page: currentPage, limit: _replyLimit);
      if (result.state == ReplyResultState.isData) {
        final replyPayload = result.response.payload;
        final newReplies = replyPayload?.replies ?? [];
        comment.replies ??= getpostbyid.Repliesreplies(
          replies: [],
          repliesCount: 0,
          totalCount: 0,
        );
        comment.replies!.replies ??= [];
        final existingIds = comment.replies!.replies!.map((r) => r.id).toSet();
        final uniqueNewReplies = (newReplies as Iterable<getpostbyid.Reply>)
            .where((r) => r.id != null && !existingIds.contains(r.id));
        comment.replies!.replies!.addAll(uniqueNewReplies);
        // Update repliesCount and totalCount from the response
        comment.replies!.repliesCount =
            replyPayload?.repliesCount ?? comment.replies!.repliesCount;
        comment.replies!.totalCount =
            replyPayload?.totalCount ?? comment.replies!.totalCount;
        // Update hasMoreReplies based on replies_count and total_count from the server response
        final fetchedCount = comment.replies!.replies?.length ?? 0;
        final totalCount = replyPayload?.totalCount ?? 0;
        _hasMoreReplies[commentId] = fetchedCount < totalCount;
        _replyPage[commentId] = currentPage + 1;
      }
    } catch (e) {
      // Optionally handle error
    }
    _isLoadingMoreReplies[commentId] = false;
    notifyListeners();
  }

  Future<void> loadMoreNestedReplies(String replyId) async {
    if (_isLoadingMoreNestedReplies[replyId] == true) return;
    _isLoadingMoreNestedReplies[replyId] = true;
    _nestedReplyResults[replyId] = NestedReplyResult(
        NestedReplyResultState.isLoading,
        more_reply_to_reply.MoreReplyToReplyModel());
    notifyListeners();

    // Find the reply
    final comments = commentResult.response.payload?.comments?.comments;
    Reply? targetReply;
    for (final comment in comments ?? []) {
      final replies = comment.replies?.replies;
      if (replies != null) {
        targetReply = replies.firstWhere((r) => r.id == replyId,
            orElse: () => getpostbyid.Reply());
        if (targetReply?.id != null) break;
      }
    }

    if (targetReply == null) {
      _isLoadingMoreNestedReplies[replyId] = false;
      notifyListeners();
      return;
    }

    int currentPage = _nestedReplyPage[replyId] ?? 1;

    try {
      final result = await postRepository.getNestedReplies(replyId,
          page: currentPage, limit: _nestedReplyLimit);
      _nestedReplyResults[replyId] =
          NestedReplyResult(result.state, result.response);
      if (result.state == NestedReplyResultState.isData) {
        final replyPayload = result.response;
        final newNestedReplies =
            (replyPayload.payload ?? []).map(payloadToReply);
        targetReply.repliesToReplies ??= getpostbyid.Repliesreplies(
          replies: [],
          repliesCount: 0,
          totalCount: 0,
        );
        targetReply.repliesToReplies!.replies ??= [];
        final existingIds =
            targetReply.repliesToReplies!.replies!.map((r) => r.id).toSet();
        final uniqueNewReplies = newNestedReplies
            .where((r) => r.id != null && !existingIds.contains(r.id));
        targetReply.repliesToReplies!.replies!.addAll(uniqueNewReplies);
        // Update repliesCount and totalCount from the response
        targetReply.repliesToReplies!.repliesCount =
            replyPayload.repliesCount ??
                targetReply.repliesToReplies!.repliesCount;
        targetReply.repliesToReplies!.totalCount =
            replyPayload.totalCount ?? targetReply.repliesToReplies!.totalCount;
        // Update hasMoreNestedReplies based on replies_count and total_count from the server response
        final fetchedCount = targetReply.repliesToReplies!.replies?.length ?? 0;
        final totalCount = replyPayload.totalCount ?? 0;
        _hasMoreNestedReplies[replyId] = fetchedCount < totalCount;
        _nestedReplyPage[replyId] = currentPage + 1;
      }
    } catch (e) {
      _nestedReplyResults[replyId] = NestedReplyResult(
          NestedReplyResultState.isError,
          more_reply_to_reply.MoreReplyToReplyModel());
      // Optionally handle error
    }
    _isLoadingMoreNestedReplies[replyId] = false;
    notifyListeners();
  }

  // Call this when leaving post_detail_page to clear all per-comment reply state
  void clearRepliesState() {
    _replyPage.clear();
    _hasMoreReplies.clear();
    _isLoadingMoreReplies.clear();
    _nestedReplyPage.clear();
    _hasMoreNestedReplies.clear();
    _isLoadingMoreNestedReplies.clear();
  }

  // Helper to convert MoreReplyToReplyModel.Payload to getpostbyid.Reply
  getpostbyid.Reply payloadToReply(more_reply_to_reply.Payload p) {
    return getpostbyid.Reply(
      id: p.id,
      commentId: p.commentId,
      reply: p.reply,
      userId: p.userId,
      userImage: p.userImage,
      userName: p.userName,
      // Add other fields as needed, or leave as null/default
    );
  }
}
