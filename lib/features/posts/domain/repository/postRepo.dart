import 'dart:developer';

import '../../../../core/exceptions/network_exception.dart';
import '../../data/repository/post_repo.dart';
import '../../domain/utils/states/postStates.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<PostResult> getpost({int page = 1, int limit = 10});
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
}
