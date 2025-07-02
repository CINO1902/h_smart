import 'package:flutter/material.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart' hide Comment;
import 'package:h_smart/features/posts/domain/repository/postRepo.dart';
import 'package:h_smart/features/posts/domain/utils/states/postStates.dart';

import '../../domain/entities/createComment.dart';
import '../../domain/entities/createreplyResponse.dart';
import '../../domain/entities/getpostbyId.dart';

class PostController extends ChangeNotifier {
  final PostRepository postRepository;

  PostController(this.postRepository) {
    if (postResult.state != PostResultState.isLoading ||
        postResult.state != PostResultState.isData) {
      getpost();
    }
  }

  PostResult postResult = PostResult(PostResultState.isLoading, GetPost());
  CommentResult commentResult =
      CommentResult(CommentResultState.isLoading, GetPostById());
  CreateCommentResult createCommentResult =
      CreateCommentResult(CreateCommentResultState.isLoading, CreateComment());
  CreateReplyResult createReplyResult = CreateReplyResult(
      CreateReplyResultState.isLoading, CreateReplyResponse());
  List<dynamic> _allPosts = [];
  int _currentPage = 1;
  int _limit = 10;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  int _commentsPage = 1;
  final int _commentsLimit = 5;
  bool _hasMoreComments = true;
  bool _isLoadingMoreComments = false;
  List<Comment> _allComments = [];

  // Reply pagination state per comment
  final Map<String, int> _replyPage = {};
  final Map<String, bool> _hasMoreReplies = {};
  final Map<String, bool> _isLoadingMoreReplies = {};
  final int _replyLimit = 3;

  List<dynamic> get allPosts => _allPosts;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;
  List<Comment> get allComments => _allComments;
  bool get hasMoreComments => _hasMoreComments;
  bool get isLoadingMoreComments => _isLoadingMoreComments;
  bool hasMoreRepliesForComment(String commentId) =>
      _hasMoreReplies[commentId] ?? false;
  bool isLoadingMoreRepliesForComment(String commentId) =>
      _isLoadingMoreReplies[commentId] ?? false;

  Future<void> getpost() async {
    _currentPage = 1;
    _allPosts = [];
    _hasMoreData = true;

    postResult = PostResult(PostResultState.isLoading, GetPost());
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
      postResult = PostResult(
          PostResultState.isError, GetPost(message: "Failed to load posts"));
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

  void refreshPosts() {
    getpost();
  }

  Future<void> getComments(String postId, {int page = 1, int? limit}) async {
    if (page == 1) {
      commentResult =
          CommentResult(CommentResultState.isLoading, GetPostById());
      _allComments = [];
      _hasMoreComments = true;
      _commentsPage = 1;
    }
    notifyListeners();
    final result = await postRepository.getComments(postId,
        commentPage: page, commentLimit: limit ?? _commentsLimit);
    if (result.state == CommentResultState.isData) {
      final newComments = result.response.payload?.comments ?? [];
      final totalCount = result.response.payload?.commentsCount ?? 0;
      if (page == 1) {
        _allComments = newComments;
      } else {
        _allComments.addAll(newComments);
      }
      // Update the payload's comments so UI using commentResult still works
      result.response.payload?.comments = _allComments;
      commentResult = result;
      _hasMoreComments = _allComments.length < totalCount;
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
      final newComments = result.response.payload?.comments ?? [];
      final totalCount = result.response.payload?.commentsCount ?? 0;
      _allComments.addAll(newComments);
      // Update the payload's comments so UI using commentResult still works
      commentResult.response.payload?.comments = _allComments;
      _hasMoreComments = _allComments.length < totalCount;
      _commentsPage = nextPage;
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
        final newComment = Comment(
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
        commentResult.response.payload?.comments?.insert(0, newComment);
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
        final newReply = Reply(
          commentId: commentId,
          createdAt: newReplyPayload.createdAt,
          id: newReplyPayload.id,
          repliesToReplies: [], // Adjust if you support replies to replies
          reply:
              newReplyPayload.comment, // 'comment' in payload is the reply text
          updatedAt: newReplyPayload.updatedAt,
          userId: newReplyPayload.userId,
          userImage: newReplyPayload.userImage,
          userName: newReplyPayload.userName,
        );

        // Find the comment and insert the reply at the beginning
        final comments = commentResult.response.payload?.comments;
        if (comments != null) {
          Comment? targetComment;
          for (final c in comments) {
            if (c.id == commentId) {
              targetComment = c;
              break;
            }
          }
          if (targetComment != null) {
            targetComment.replies ??= [];
            targetComment.replies!.insert(0, newReply);
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

  Future<void> loadMoreReplies(String commentId) async {
    if (_isLoadingMoreReplies[commentId] == true) return;
    _isLoadingMoreReplies[commentId] = true;
    notifyListeners();

    // Find the comment
    final comments = commentResult.response.payload?.comments;
    final comment =
        comments?.firstWhere((c) => c.id == commentId, orElse: () => Comment());
    if (comment == null) {
      _isLoadingMoreReplies[commentId] = false;
      notifyListeners();
      return;
    }

    int currentPage = _replyPage[commentId] ?? 1;
    int nextPage = currentPage + 1;

    // Fetch more replies (assume postRepository.getReplies exists, or will add)
    try {
      final result = await postRepository.getReplies(commentId,
          page: nextPage, limit: _replyLimit);
      if (result.state == CommentResultState.isData) {
        final newReplies = result.response.payload?.replies ?? [];
        comment.replies ??= [];
        comment.replies!.addAll(newReplies);
        // Update hasMoreReplies based on replies_count
        final totalReplies = comment.repliesCount ?? 0;
        _hasMoreReplies[commentId] = comment.replies!.length < totalReplies;
        _replyPage[commentId] = nextPage;
      }
    } catch (e) {
      // Optionally handle error
    }
    _isLoadingMoreReplies[commentId] = false;
    notifyListeners();
  }
}
