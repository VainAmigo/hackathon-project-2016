/// Модели, соответствующие DTO бэкенда (`docs/chat/dto`).
library;

/// [SourceDto]
class ChatSourceRef {
  const ChatSourceRef({this.documentId});

  final int? documentId;

  factory ChatSourceRef.fromJson(Map<String, dynamic> json) {
    final raw = json['documentId'];
    int? id;
    if (raw is int) {
      id = raw;
    } else if (raw is num) {
      id = raw.toInt();
    }
    return ChatSourceRef(documentId: id);
  }
}

/// [MessageDto]
class ChatMessage {
  const ChatMessage({
    this.id,
    required this.question,
    required this.answer,
    this.sources = const [],
    this.createdAt,
  });

  final int? id;
  final String question;
  final String answer;
  final List<ChatSourceRef> sources;
  final DateTime? createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final sourcesJson = json['sources'];
    final sources = <ChatSourceRef>[];
    if (sourcesJson is List) {
      for (final e in sourcesJson) {
        if (e is Map<String, dynamic>) {
          sources.add(ChatSourceRef.fromJson(e));
        }
      }
    }
    return ChatMessage(
      id: (json['id'] as num?)?.toInt(),
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      sources: sources,
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

/// [ChatDto] — элемент списка чатов без сообщений.
class ChatListItem {
  const ChatListItem({
    required this.id,
    required this.title,
    this.createdAt,
  });

  final int id;
  final String title;
  final DateTime? createdAt;

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

/// [ChatWithMessagesDto]
class ChatWithMessages {
  const ChatWithMessages({
    required this.id,
    required this.title,
    this.createdAt,
    this.messages = const [],
  });

  final int id;
  final String title;
  final DateTime? createdAt;
  final List<ChatMessage> messages;

  factory ChatWithMessages.fromJson(Map<String, dynamic> json) {
    final msgJson = json['messages'];
    final messages = <ChatMessage>[];
    if (msgJson is List) {
      for (final e in msgJson) {
        if (e is Map<String, dynamic>) {
          messages.add(ChatMessage.fromJson(e));
        }
      }
    }
    return ChatWithMessages(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      createdAt: _parseDate(json['createdAt']),
      messages: messages,
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  if (raw is String) {
    return DateTime.tryParse(raw);
  }
  return null;
}
