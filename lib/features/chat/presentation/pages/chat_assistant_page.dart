import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/chat/presentation/widgets/chat_composer_bar.dart';
import 'package:project_temp/features/chat/presentation/widgets/chat_messages_view.dart';
import 'package:project_temp/features/chat/presentation/widgets/chat_sidebar_panel.dart';
import 'package:project_temp/source/source.dart';

/// Экран ассистента: список чатов, лента обменов, [ChatsRepository].
class ChatAssistantPage extends StatefulWidget {
  const ChatAssistantPage({super.key});

  @override
  State<ChatAssistantPage> createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final _composer = TextEditingController();
  final _drawerKey = GlobalKey<ScaffoldState>();

  ChatsRepository get _repo => sl<ChatsRepository>();

  List<ChatSummary> _chatSummaries = [];
  final Map<int, List<ChatMessageResponse>> _messagesByChatId = {};
  int? _selectedChatId;

  bool _loadingChats = false;
  bool _sending = false;
  String? _listError;

  /// Загрузка GET /chats/{id} для выбранного чата.
  int? _loadingThreadChatId;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  Future<void> _loadChats() async {
    setState(() {
      _loadingChats = true;
      _listError = null;
    });
    final result = await _repo.listChats();
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loadingChats = false;
        _listError = f.message;
      }),
      (list) {
        final sorted = [...list]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        setState(() {
          _loadingChats = false;
          _chatSummaries = sorted;
          _listError = null;
        });
      },
    );
  }

  /// После POST /chats id сессии берём из обновлённого списка (самый новый по дате).
  int _resolveChatId(ChatMessageResponse exchange, List<ChatSummary> list) {
    if (list.isEmpty) return exchange.id;
    final sorted = [...list]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.first.id;
  }

  List<ChatMessageResponse> get _currentMessages {
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
      _loadingThreadChatId = null;
    });
    _drawerKey.currentState?.closeDrawer();
  }

  Future<void> _onSelectChat(int id) async {
    _drawerKey.currentState?.closeDrawer();
    setState(() {
      _selectedChatId = id;
      _loadingThreadChatId = id;
    });

    final result = await _repo.getChat(id);
    if (!mounted || _selectedChatId != id) return;

    result.fold(
      (f) {
        if (!mounted || _selectedChatId != id) return;
        setState(() => _loadingThreadChatId = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
      (detail) {
        if (!mounted || _selectedChatId != id) return;
        final ordered = [...detail.messages]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        setState(() {
          _loadingThreadChatId = null;
          _messagesByChatId[id] = ordered;
          _applySummaryFromDetail(detail);
        });
      },
    );
  }

  void _applySummaryFromDetail(ChatDetail detail) {
    final i = _chatSummaries.indexWhere((c) => c.id == detail.id);
    if (i < 0) return;
    final next = [..._chatSummaries];
    next[i] = ChatSummary(
      id: detail.id,
      title: detail.title,
      createdAt: detail.createdAt,
    );
    _chatSummaries = next;
  }

  Future<void> _onSend() async {
    final q = _composer.text.trim();
    if (q.isEmpty || _sending) return;

    setState(() => _sending = true);

    if (_selectedChatId == null) {
      final createResult = await _repo.createChat(q);
      if (!mounted) return;
      await createResult.fold<Future<void>>(
        (f) async {
          if (!mounted) return;
          setState(() => _sending = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(f.message)),
          );
        },
        (msg) async {
          final listResult = await _repo.listChats();
          if (!mounted) return;
          listResult.fold(
            (f) {
              if (!mounted) return;
              final chatId = _resolveChatId(msg, const []);
              setState(() {
                _sending = false;
                _messagesByChatId[chatId] = [msg];
                _selectedChatId = chatId;
              });
              _composer.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(f.message)),
              );
            },
            (list) {
              if (!mounted) return;
              final sorted = [...list]
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              final chatId = _resolveChatId(msg, sorted);
              setState(() {
                _sending = false;
                _chatSummaries = sorted;
                _messagesByChatId[chatId] = [msg];
                _selectedChatId = chatId;
              });
              _composer.clear();
            },
          );
        },
      );
      return;
    }

    final chatId = _selectedChatId!;
    final sendResult = await _repo.sendMessage(chatId, q);
    if (!mounted) return;
    sendResult.fold(
      (f) {
        if (!mounted) return;
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
      (msg) {
        if (!mounted) return;
        final list =
            List<ChatMessageResponse>.from(_messagesByChatId[chatId] ?? []);
        list.add(msg);
        setState(() {
          _sending = false;
          _messagesByChatId[chatId] = list;
        });
        _composer.clear();
      },
    );
  }

  ChatSummary? get _selectedSummary {
    final id = _selectedChatId;
    if (id == null) return null;
    for (final c in _chatSummaries) {
      if (c.id == id) return c;
    }
    return null;
  }

  bool get _threadLoading =>
      _loadingThreadChatId != null &&
      _loadingThreadChatId == _selectedChatId &&
      _selectedChatId != null;

  @override
  Widget build(BuildContext context) {
    final a = context.adaptive;
    final wideSidebar = a.canUseSideNavigation;
    final l10n = context.l10n;

    final Widget sidebar = _loadingChats && _chatSummaries.isEmpty
        ? Material(
            color: AppThemes.surfaceColor,
            child: const Center(child: CircularProgressIndicator()),
          )
        : _listError != null && _chatSummaries.isEmpty
            ? Material(
                color: AppThemes.surfaceColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _listError!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppThemes.textColorSecondary,
                              ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _loadChats,
                          child: Text(l10n.chatRetryLoad),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ChatSidebarPanel(
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
                subtitle: _selectedSummary != null
                    ? Text(
                        _selectedSummary!.title.isEmpty
                            ? l10n.chatUntitled
                            : _selectedSummary!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(l10n.chatNewChat),
              ),
            ),
          ),
        Expanded(
          child: _threadLoading
              ? const Center(child: CircularProgressIndicator())
              : ChatMessagesView(
                  messages: _currentMessages,
                  emptyTitle: l10n.chatEmptyThreadTitle,
                  emptySubtitle: l10n.chatEmptyThreadSubtitle,
                ),
        ),
        ChatComposerBar(
          controller: _composer,
          hintText: l10n.chatComposerHint,
          onSend: () {
            _onSend();
          },
          enabled: !_sending && !_threadLoading,
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
