// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSummary _$ChatSummaryFromJson(Map<String, dynamic> json) => ChatSummary(
  id: apiIntIdFromJson(json['id']),
  title: json['title'] as String,
  createdAt: apiDateTimeFromJson(json['createdAt']),
);

Map<String, dynamic> _$ChatSummaryToJson(ChatSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
    };
