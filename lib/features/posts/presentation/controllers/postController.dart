import 'package:flutter/material.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import 'package:h_smart/features/posts/domain/repository/postRepo.dart';
import 'package:h_smart/features/posts/domain/utils/states/postStates.dart';

class PostController extends ChangeNotifier {
  final PostRepository postRepository;

  PostController(this.postRepository) {
    getpost();
  }

  PostResult postResult = PostResult(PostResultState.isLoading, GetPost());
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
}
