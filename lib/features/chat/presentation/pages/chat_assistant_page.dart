import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/chat/domain/chat_models.dart';
import 'package:project_temp/features/chat/presentation/widgets/chat_composer_bar.dart';
import 'package:project_temp/features/chat/presentation/widgets/chat_messages_view.dart';
import 'package:project_temp/features/chat/presentation/widgets/chat_sidebar_panel.dart';

/// Экран ассистента: список чатов слева (или в drawer), лента [MessageDto], ввод [SendMessageRequest].
class ChatAssistantPage extends StatefulWidget {
  const ChatAssistantPage({super.key});

  @override
  State<ChatAssistantPage> createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final _composer = TextEditingController();
  final _drawerKey = GlobalKey<ScaffoldState>();
  int _nextId = 3;

  late List<ChatListItem> _chatSummaries;
  late Map<int, List<ChatMessage>> _messagesByChatId;
  int? _selectedChatId;

  @override
  void initState() {
    super.initState();
    _chatSummaries = [
      const ChatListItem(
        id: 1,
        title: 'Rehabilitation fields',
      ),
      const ChatListItem(
        id: 2,
        title: 'Answer sources',
      ),
    ];
    _messagesByChatId = {
      1: [
        ChatMessage(
          id: 101,
          question:
              'Which archive card fields relate to rehabilitation?',
          answer:
              'Typically: rehabilitation date, wording of the decision, and a '
              'reference to the legal act when present in the materials.',
          sources: [
            const ChatSourceRef(documentId: 12),
            const ChatSourceRef(documentId: 45),
          ],
        ),
      ],
      2: [
        const ChatMessage(
          id: 201,
          question: 'Where do the sources in the answer come from?',
          answer:
              'The API returns a list of SourceDto with documentId per cited '
              'fragment. In the UI they work well as chips linking to documents.',
          sources: [ChatSourceRef(documentId: 3)],
        ),
      ],
    };
    _selectedChatId = null;
  }

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  List<ChatMessage> get _currentMessages {
    final id = _selectedChatId;
    if (id == null) return const [];
    return _messagesByChatId[id] ?? const [];
  }

  void _openDrawer() {
    _drawerKey.currentState?.openDrawer();
  }

  void _onNewChat() {
    setState(() {
      _selectedChatId = null;
    });
    _drawerKey.currentState?.closeDrawer();
  }

  void _onSelectChat(int id) {
    setState(() => _selectedChatId = id);
    _drawerKey.currentState?.closeDrawer();
  }

  void _onSend() {
    final q = _composer.text.trim();
    if (q.isEmpty) return;
    final mockAnswer = context.l10n.chatMockAnswerPlaceholder;

    setState(() {
      final msg = ChatMessage(
        question: q,
        answer: mockAnswer,
        sources: const [ChatSourceRef(documentId: 1)],
      );

      var chatId = _selectedChatId;
      if (chatId == null) {
        chatId = _nextId++;
        final title = q.length <= 40 ? q : '${q.substring(0, 40)}…';
        _chatSummaries = [
          ChatListItem(id: chatId, title: title),
          ..._chatSummaries,
        ];
        _messagesByChatId[chatId] = [msg];
        _selectedChatId = chatId;
      } else {
        final list = List<ChatMessage>.from(_messagesByChatId[chatId] ?? []);
        list.add(msg);
        _messagesByChatId[chatId] = list;
      }
      _composer.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = context.adaptive;
    final wideSidebar = a.canUseSideNavigation;
    final l10n = context.l10n;

    final sidebar = ChatSidebarPanel(
      chats: _chatSummaries,
      selectedChatId: _selectedChatId,
      onSelectChat: _onSelectChat,
      onNewChat: _onNewChat,
    );

    final thread = Column(
      children: [
        if (!wideSidebar)
          Material(
            color: AppThemes.surfaceColor,
            child: SafeArea(
              bottom: false,
              child: ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  color: AppThemes.accentColor,
                  onPressed: _openDrawer,
                  tooltip: l10n.chatOpenChatsListTooltip,
                ),
                title: Text(
                  l10n.chatThreadTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppThemes.textColorPrimary,
                      ),
                ),
                subtitle: _selectedChatId != null
                    ? Text(
                        _chatSummaries
                            .firstWhere((c) => c.id == _selectedChatId)
                            .title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(l10n.chatNewChat),
              ),
            ),
          ),
        Expanded(
          child: ChatMessagesView(
            messages: _currentMessages,
            emptyTitle: l10n.chatEmptyThreadTitle,
            emptySubtitle: l10n.chatEmptyThreadSubtitle,
          ),
        ),
        ChatComposerBar(
          controller: _composer,
          hintText: l10n.chatComposerHint,
          onSend: _onSend,
        ),
      ],
    );

    if (wideSidebar) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 272,
            child: sidebar,
          ),
          Expanded(
            child: ColoredBox(
              color: AppThemes.backgroundColor,
              child: thread,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      key: _drawerKey,
      backgroundColor: AppThemes.backgroundColor,
      drawer: Drawer(
        width: 288,
        backgroundColor: AppThemes.surfaceColor,
        child: sidebar,
      ),
      body: thread,
    );
  }
}
