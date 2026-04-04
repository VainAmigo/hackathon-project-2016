// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSourceRef _$ChatSourceRefFromJson(Map<String, dynamic> json) =>
    ChatSourceRef(documentId: personIdFromJson(json['documentId']));

Map<String, dynamic> _$ChatSourceRefToJson(ChatSourceRef instance) =>
    <String, dynamic>{'documentId': instance.documentId};

ChatMessageResponse _$ChatMessageResponseFromJson(Map<String, dynamic> json) =>
    ChatMessageResponse(
      id: apiIntIdFromJson(json['id']),
      question: json['question'] as String,
      answer: json['answer'] as String,
      sources: (json['sources'] as List<dynamic>)
          .map((e) => ChatSourceRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: apiDateTimeFromJson(json['createdAt']),
    );

Map<String, dynamic> _$ChatMessageResponseToJson(
  ChatMessageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'answer': instance.answer,
  'sources': instance.sources,
  'createdAt': instance.createdAt.toIso8601String(),
};
