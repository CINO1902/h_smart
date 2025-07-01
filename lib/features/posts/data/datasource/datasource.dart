import 'package:h_smart/core/service/http_service.dart';

import '../../../../constant/enum.dart';
import '../../domain/entities/createComment.dart';
import '../../domain/entities/getpostbyId.dart';
import '../../domain/entities/post.dart';
import '../../domain/utils/states/postStates.dart';
import '../repository/post_repo.dart';

class PostDatasourceImp implements PostDataSource {
  final HttpService httpService;

  PostDatasourceImp(this.httpService);

  @override
  Future<PostResult> getpost({int page = 1, int limit = 10}) async {
    final response = await httpService.request(
        url: '/posts/get_all_posts?page=$page&limit=$limit',
        methodrequest: RequestMethod.getWithToken);
    PostResult postResult = PostResult(PostResultState.isLoading, GetPost());
    if (response.statusCode == 200) {
      final decodedData = GetPost.fromJson(response.data);
      postResult = PostResult(PostResultState.isData, decodedData);
    }
    return postResult;
  }

  @override
  Future<CommentResult> getComments(String postId,
      {int commentPage = 1, int commentLimit = 10}) async {
    CommentResult commentResult =
        CommentResult(CommentResultState.isLoading, GetPostById());
    final response = await httpService.request(
        url:
            '/posts/get_post_by_id/$postId?comments_page=$commentPage&comments_per_page=$commentLimit&replies_page=1&replies_per_page=1',
        methodrequest: RequestMethod.getWithToken);

    if (response.statusCode == 200) {
      final decodedData = GetPostById.fromJson(response.data);
      commentResult = CommentResult(CommentResultState.isData, decodedData);
    }
    return commentResult;
  }

  @override
  Future<CreateCommentResult> createComment(
      String postId, String comment) async {
    CreateCommentResult createCommentResult = CreateCommentResult(
        CreateCommentResultState.isLoading, CreateComment());
    final response = await httpService.request(
        url: '/posts/create_comment',
        methodrequest: RequestMethod.postWithToken,
        data: {'post_id': postId, 'comment': comment});

    if (response.statusCode == 201) {
      final decodedData = CreateComment.fromJson(response.data);
      createCommentResult =
          CreateCommentResult(CreateCommentResultState.isData, decodedData);
    }
    return createCommentResult;
  }
}
