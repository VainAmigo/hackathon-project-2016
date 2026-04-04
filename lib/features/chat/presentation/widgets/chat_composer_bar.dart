import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';

/// Нижняя панель: ввод [SendMessageRequest.question] и отправка.
class ChatComposerBar extends StatelessWidget {
  const ChatComposerBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSend,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemes.surfaceColor,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: hintText,
                    filled: true,
                    fillColor: AppThemes.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: AppThemes.textColorGrey.withValues(alpha: 0.35),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: AppThemes.textColorGrey.withValues(alpha: 0.35),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: AppThemes.accentColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppThemes.textColorPrimary,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: enabled ? onSend : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppThemes.accentColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppThemes.textColorGrey.withValues(alpha: 0.25),
                ),
                icon: const Icon(Icons.send_rounded, size: 22),
                tooltip: context.l10n.chatSendTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
