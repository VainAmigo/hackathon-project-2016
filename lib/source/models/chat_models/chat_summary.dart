import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:project_temp/source/models/json_converters.dart';

part 'chat_summary.g.dart';

/// Элемент списка GET /api/v1/chats.
@JsonSerializable()
class ChatSummary extends Equatable {
  const ChatSummary({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  @JsonKey(fromJson: apiIntIdFromJson)
  final int id;
  final String title;
  @JsonKey(fromJson: apiDateTimeFromJson)
  final DateTime createdAt;

  factory ChatSummary.fromJson(Map<String, dynamic> json) =>
      _$ChatSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSummaryToJson(this);

  @override
  List<Object?> get props => [id, title, createdAt];
}
