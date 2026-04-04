import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/error/failures.dart';
import 'package:project_temp/source/models/chat_models/chat_detail.dart';
import 'package:project_temp/source/models/chat_models/chat_message_response.dart';
import 'package:project_temp/source/models/chat_models/chat_summary.dart';

abstract class ChatsRepository {
  /// GET /api/v1/chats
  Future<Either<Failure, List<ChatSummary>>> listChats();

  /// GET /api/v1/chats/{id} — детали и история сообщений.
  Future<Either<Failure, ChatDetail>> getChat(int chatId);

  /// POST /api/v1/chats — новый чат с первым вопросом.
  Future<Either<Failure, ChatMessageResponse>> createChat(String question);

  /// POST /api/v1/chats/{chatId}/messages — продолжение чата.
  Future<Either<Failure, ChatMessageResponse>> sendMessage(
    int chatId,
    String question,
  );
}
