import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';

/// Пустое состояние превью архива на главной (под заголовком секции).
class HomeArchiveEmptyPlaceholder extends StatelessWidget {
  const HomeArchiveEmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppThemes.surfaceColor,
          border: Border.all(
            color: AppThemes.textColorGrey.withValues(alpha: 0.14),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 40,
                color: AppThemes.textColorGrey.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.archiveHomePreviewEmpty,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppThemes.textColorSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
