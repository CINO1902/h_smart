import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domains/repositories/chat_repo.dart';
import '../../domains/utils/states.dart';

class ChatController extends ChangeNotifier {
  final ChatRepository chatRepository;
  ChatController(this.chatRepository);

  GetChatResult getChatResult = GetChatResult(GetChatResultState.isNull, {});
  SyncLastChatResult syncLastChatResult =
      SyncLastChatResult(SyncLastChatResultStates.isEmpty, {});
  GetConversationResult getConversatonResult =
      GetConversationResult(GetConversatonResultState.isEmpty, {});
  Future<void> getallMessages(conversation) async {
    getChatResult = GetChatResult(GetChatResultState.isLoading, {});
    notifyListeners();
    final response = await chatRepository.getallMessage(conversation);

    getChatResult = response;
    notifyListeners();
  }

  void updatemessage() {
    getChatResult = GetChatResult(GetChatResultState.isData, {});
    notifyListeners();
  }

  Future<void> getConversation(userId, WidgetRef ref) async {
    getConversatonResult = GetConversationResult(GetConversatonResultState.isLoading, {});
    notifyListeners();
    final response = await chatRepository.getConversation(userId);

    getConversatonResult = response;
    if (getConversatonResult.state == GetChatResultState.isData) {
      final pref = await SharedPreferences.getInstance();
      // print('ConvoId from Backend ${getConVoIDResult.response}');
      // ref.read(convoMongoProvider.notifier).state = getConVoIDResult.response;
      // pref.setString('convoId', getConVoIDResult.response);
    } else {
      // ref.read(convoMongoProvider.notifier).state = '67d2eddda33c0f86f2e9938d';
    }
    notifyListeners();
  }

  Future<void> syncMessage(conversation, lastmessageTimeStamp) async {
    syncLastChatResult =
        SyncLastChatResult(SyncLastChatResultStates.isLoading, {});
    notifyListeners();
    final response = await chatRepository.synclastmessage(
        conversation, lastmessageTimeStamp);

    syncLastChatResult = response;
    notifyListeners();
  }
}
