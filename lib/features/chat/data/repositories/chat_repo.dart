import '../../domains/utils/states.dart';

abstract class ChatDataSource {
  Future<GetChatResult> getallMessage(String converstionId);
  Future<GetConversationResult> getConversation(userId);
  Future<SyncLastChatResult> synclastmessage(
      converstionId, lastMessageTimestamp);
}