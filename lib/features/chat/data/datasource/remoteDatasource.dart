import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domains/utils/states.dart';
import '../repositories/chat_repo.dart';

class ChatDatasourceImp implements ChatDataSource {
  final HttpService httpService;

  ChatDatasourceImp(this.httpService);

  @override
  Future<GetChatResult> getallMessage(String converstionId) async {
    GetChatResult getChatResult = GetChatResult(GetChatResultState.isEmpty, {});
    // final int = 8920222;
    final response = await httpService.request(
      url: '/$converstionId/messages',
      methodrequest: RequestMethod.get,
    );
    if (response.statusCode == 200) {
      getChatResult = GetChatResult(GetChatResultState.isData, response.data);
    } else {
      getChatResult = GetChatResult(GetChatResultState.isError, response.data);
    }

    return getChatResult;
  }

  @override
  Future<SyncLastChatResult> synclastmessage(
      conversationId, lastMessageTimestamp) async {
    SyncLastChatResult syncLastChatResult =
        SyncLastChatResult(SyncLastChatResultStates.isEmpty, {});
    print(lastMessageTimestamp);
    final response = await httpService.request(
      url:
          '/conversations/$conversationId/messages?since=$lastMessageTimestamp',
      methodrequest: RequestMethod.get,
    );
    if (response.statusCode == 200) {
      syncLastChatResult =
          SyncLastChatResult(SyncLastChatResultStates.isData, response.data);
    } else {
      syncLastChatResult =
          SyncLastChatResult(SyncLastChatResultStates.isError, response.data);
    }
    return syncLastChatResult;
  }

  @override
  Future<GetConversationResult> getConversation(userId) async {
    GetConversationResult getConversationResult =
        GetConversationResult(GetConversatonResultState.isLoading, {});

    final response = await httpService.request(
      url: '/getConversation',
      methodrequest: RequestMethod.getWithToken,
    );

    if (response.statusCode == 200) {
      getConversationResult = GetConversationResult(
          GetConversatonResultState.isData, response.data);
    } else {
      getConversationResult = GetConversationResult(
          GetConversatonResultState.isError, response.data);
    }
    return getConversationResult;
  }
}
