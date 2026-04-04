// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDetail _$ChatDetailFromJson(Map<String, dynamic> json) => ChatDetail(
  id: apiIntIdFromJson(json['id']),
  title: _chatTitleFromJson(json['title']),
  createdAt: apiDateTimeFromJson(json['createdAt']),
  messages: _messagesFromJson(json['messages']),
);

Map<String, dynamic> _$ChatDetailToJson(ChatDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'messages': instance.messages,
    };
