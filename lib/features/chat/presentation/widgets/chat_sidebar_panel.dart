import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/models/chat_models/chat_summary.dart';

/// Левая колонка: список чатов + «новый чат».
class ChatSidebarPanel extends StatelessWidget {
  const ChatSidebarPanel({
    super.key,
    required this.chats,
    required this.selectedChatId,
    required this.onSelectChat,
    required this.onNewChat,
  });

  final List<ChatSummary> chats;
  final int? selectedChatId;
  final ValueChanged<int> onSelectChat;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppThemes.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.chatSidebarTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppThemes.textColorSecondary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FilledButton.tonal(
              onPressed: onNewChat,
              style: FilledButton.styleFrom(
                backgroundColor: AppThemes.backgroundColor,
                foregroundColor: AppThemes.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    color: AppThemes.accentColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
              child: Text(l10n.chatNewChat),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final c = chats[index];
                final selected = selectedChatId == c.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: selected
                        ? AppThemes.accentColor.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      onTap: () => onSelectChat(c.id),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          c.title.isEmpty ? l10n.chatUntitled : c.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppThemes.textColorPrimary,
                                fontWeight:
                                    selected ? FontWeight.w600 : FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
