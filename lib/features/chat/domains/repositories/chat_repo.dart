import 'dart:developer';

import '../../../../constant/enum.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../data/repositories/chat_repo.dart';
import '../utils/states.dart';

abstract class ChatRepository {
  Future<GetChatResult> getallMessage(String converstionId);
  Future<GetConversationResult> getConversation(userId);
  Future<SyncLastChatResult> synclastmessage(
      converstionId, lastMessageTimestamp);
}

class ChatRepositoryImp implements ChatRepository {
  final ChatDataSource chatDatasource;
  ChatRepositoryImp(this.chatDatasource);

  @override
  Future<GetChatResult> getallMessage(converstionId) async {
    GetChatResult getChatResult = GetChatResult(GetChatResultState.isEmpty, {});

    try {
      // final newId = int.parse(converstionId);
      getChatResult = await chatDatasource.getallMessage(converstionId);
    } catch (e) {
      // log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        print(exp.type);
        //
        if (exp.type == NetworkExceptionType.notFound) {
          getChatResult = GetChatResult(GetChatResultState.isEmpty,
              {"message": 'You haven\'t had a conversation with the admin'});
        } else {
          getChatResult =
              GetChatResult(GetChatResultState.isError, {"message": message});
        }
      } else {
        getChatResult = GetChatResult(
            GetChatResultState.isError, {"message": "Something Went Wrong"});
      }
    }
    return getChatResult;
  }

  @override
  Future<SyncLastChatResult> synclastmessage(
      converstionId, lastMessageTimestamp) async {
    SyncLastChatResult syncLastChatResult =
        SyncLastChatResult(SyncLastChatResultStates.isEmpty, {});

    try {
      syncLastChatResult = await chatDatasource.synclastmessage(
          converstionId, lastMessageTimestamp);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        syncLastChatResult = SyncLastChatResult(
            SyncLastChatResultStates.isError, {"message": message});
      } else {
        syncLastChatResult = SyncLastChatResult(
            SyncLastChatResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return syncLastChatResult;
  }

  @override
  Future<GetConversationResult> getConversation(userId) async {
    GetConversationResult getConVoIDResult =
        GetConversationResult(GetConversatonResultState.isEmpty, {});

    try {
      getConVoIDResult = await chatDatasource.getConversation(userId);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        getConVoIDResult = GetConversationResult(
            GetConversatonResultState.isError, {"message": message});
      } else {
        getConVoIDResult = GetConversationResult(
            GetConversatonResultState.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return getConVoIDResult;
  }
}
