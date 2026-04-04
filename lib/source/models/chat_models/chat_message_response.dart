import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:project_temp/source/models/json_converters.dart';

part 'chat_message_response.g.dart';

/// Ссылка на документ в ответе чата (сервер может вернуть `documentId: null`).
@JsonSerializable()
class ChatSourceRef extends Equatable {
  const ChatSourceRef({this.documentId});

  @JsonKey(fromJson: personIdFromJson)
  final int? documentId;

  factory ChatSourceRef.fromJson(Map<String, dynamic> json) =>
      _$ChatSourceRefFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSourceRefToJson(this);

  @override
  List<Object?> get props => [documentId];
}

/// Ответ POST /api/v1/chats и POST /api/v1/chats/{id}/messages.
@JsonSerializable()
class ChatMessageResponse extends Equatable {
  const ChatMessageResponse({
    required this.id,
    required this.question,
    required this.answer,
    required this.sources,
    required this.createdAt,
  });

  @JsonKey(fromJson: apiIntIdFromJson)
  final int id;
  final String question;
  final String answer;
  final List<ChatSourceRef> sources;
  @JsonKey(fromJson: apiDateTimeFromJson)
  final DateTime createdAt;

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageResponseToJson(this);

  @override
  List<Object?> get props => [id, question, answer, sources, createdAt];
}
