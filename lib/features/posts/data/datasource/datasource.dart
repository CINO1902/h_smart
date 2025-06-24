import 'package:h_smart/core/service/http_service.dart';

import '../../../../constant/enum.dart';
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
}
