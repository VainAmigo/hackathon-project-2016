import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';

/// Карточка в каталоге архива: портрет, ФИО, даты, дело №, три строки метаданных (плоский макет).
class ArchiveCatalogListCard extends StatelessWidget {
  const ArchiveCatalogListCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final ArchiveEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppThemes.accentColor.withValues(alpha: 0.08),
        highlightColor: AppThemes.accentColor.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 132,
                child: Image.asset(
                  entry.portraitAssetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: AppThemes.textColorGrey.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.person_outline,
                      size: 44,
                      color: AppThemes.textColorGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.fullName,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: AppThemes.textColorPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.archiveCardBirthLabel}: ${entry.yearFrom}'
                      ' • ${l10n.archiveCardDeathLabel}: ${entry.yearTo}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.55,
                        color: AppThemes.textColorGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.archiveCaseNumberPrefix} ${entry.caseNumber}',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppThemes.textColorPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MetaLine(
                      label: '${l10n.archiveMetaBirthPlace}:',
                      value: entry.birthPlace,
                    ),
                    const SizedBox(height: 6),
                    _MetaLine(
                      label: '${l10n.archiveMetaSocialOrigin}:',
                      value: entry.socialOrigin,
                    ),
                    const SizedBox(height: 6),
                    _MetaLine(
                      label: '${l10n.archiveMetaOccupationShort}:',
                      value: entry.occupation,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 168,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppThemes.textColorGrey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppThemes.textColorPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
