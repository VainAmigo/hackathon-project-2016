import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:project_temp/source/models/chat_models/chat_message_response.dart';
import 'package:project_temp/source/models/json_converters.dart';

part 'chat_detail.g.dart';

String _chatTitleFromJson(Object? value) => value?.toString() ?? '';

List<ChatMessageResponse> _messagesFromJson(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map>()
      .map((e) => ChatMessageResponse.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

/// GET /api/v1/chats/{id} — чат с историей сообщений.
@JsonSerializable()
class ChatDetail extends Equatable {
  const ChatDetail({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  @JsonKey(fromJson: apiIntIdFromJson)
  final int id;
  @JsonKey(fromJson: _chatTitleFromJson)
  final String title;
  @JsonKey(fromJson: apiDateTimeFromJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _messagesFromJson)
  final List<ChatMessageResponse> messages;

  factory ChatDetail.fromJson(Map<String, dynamic> json) =>
      _$ChatDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDetailToJson(this);

  @override
  List<Object?> get props => [id, title, createdAt, messages];
}
