import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Выбор языка для GET /api/v1/persons/{id}?language=…
class ArchiveEntryDetailLanguageBar extends StatelessWidget {
  const ArchiveEntryDetailLanguageBar({
    super.key,
    required this.l10n,
    required this.selected,
    required this.onSelected,
  });

  final AppLocalizations l10n;
  final AppLanguageCode selected;
  final ValueChanged<AppLanguageCode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.archiveDetailCardLanguageTitle,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppThemes.textColorGrey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final code in AppLanguageCode.values)
              ChoiceChip(
                label: Text(code.uiLabel),
                selected: selected == code,
                onSelected: (_) => onSelected(code),
                selectedColor: AppThemes.accentColor.withValues(alpha: 0.35),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected == code
                      ? AppThemes.textColorPrimary
                      : AppThemes.textColorSecondary,
                ),
                side: BorderSide(
                  color: selected == code
                      ? AppThemes.accentColor.withValues(alpha: 0.65)
                      : AppThemes.textColorGrey.withValues(alpha: 0.4),
                ),
                backgroundColor: AppThemes.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
          ],
        ),
      ],
    );
  }
}
