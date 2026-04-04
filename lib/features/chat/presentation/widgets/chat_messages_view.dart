import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/chat/domain/chat_models.dart';

/// Лента сообщений: [MessageDto.question] / [MessageDto.answer] и источники.
class ChatMessagesView extends StatelessWidget {
  const ChatMessagesView({
    super.key,
    required this.messages,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final List<ChatMessage> messages;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 48,
                color: AppThemes.textColorGrey.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppThemes.textColorPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                emptySubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.textColorSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final m = messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.82,
                  ),
                  child: _Bubble(
                    text: m.question,
                    alignRight: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.92,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bubble(
                        text: m.answer,
                        alignRight: false,
                      ),
                      if (m.sources.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _SourcesRow(sources: m.sources),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.text,
    required this.alignRight,
  });

  final String text;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final bg = alignRight
        ? AppThemes.accentColor.withValues(alpha: 0.14)
        : AppThemes.surfaceColor;
    final border = alignRight
        ? Border.all(color: AppThemes.accentColor.withValues(alpha: 0.35))
        : Border.all(color: AppThemes.textColorGrey.withValues(alpha: 0.2));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(alignRight ? 12 : 4),
          bottomRight: Radius.circular(alignRight ? 4 : 12),
        ),
        border: border,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: SelectableText(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppThemes.textColorPrimary,
                height: 1.45,
              ),
        ),
      ),
    );
  }
}

class _SourcesRow extends StatelessWidget {
  const _SourcesRow({required this.sources});

  final List<ChatSourceRef> sources;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chatSourcesHeading,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppThemes.textColorGrey,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final s in sources)
              if (s.documentId != null)
                Chip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor:
                      AppThemes.textColorGrey.withValues(alpha: 0.12),
                  side: BorderSide.none,
                  label: Text(
                    l10n.chatDocumentChipLabel(s.documentId!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppThemes.textColorSecondary,
                        ),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
