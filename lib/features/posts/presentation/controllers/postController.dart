import 'package:flutter/material.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart' hide Comment;
import 'package:h_smart/features/posts/domain/repository/postRepo.dart';
import 'package:h_smart/features/posts/domain/utils/states/postStates.dart';

import '../../domain/entities/createComment.dart';
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
  List<dynamic> _allPosts = [];
  int _currentPage = 1;
  int _limit = 10;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  List<dynamic> get allPosts => _allPosts;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

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

  Future<void> getComments(String postId) async {
    commentResult = CommentResult(CommentResultState.isLoading, GetPostById());
    notifyListeners();
    final result = await postRepository.getComments(postId);
    if (result.state == CommentResultState.isData) {
      commentResult = result;
    }
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
}
