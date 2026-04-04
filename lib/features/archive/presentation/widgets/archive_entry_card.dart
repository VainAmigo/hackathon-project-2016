import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';

/// Карточка записи на главной (макет: фото слева, текст и блок метаданных).
class ArchiveEntryCard extends StatelessWidget {
  const ArchiveEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final ArchiveEntry entry;
  final VoidCallback onTap;

  static const _titleSerif = TextStyle(
    fontFamily: 'serif',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppThemes.textColorPrimary,
  );

  static const _bodySans = TextStyle(
    fontSize: 14,
    height: 1.45,
    color: AppThemes.textColorSecondary,
  );

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
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 112,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    entry.portraitAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: AppThemes.textColorGrey.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.person_outline,
                        size: 48,
                        color: AppThemes.textColorGrey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.fullName, style: _titleSerif),
                    const SizedBox(height: 10),
                    Text(entry.listExcerpt, style: _bodySans),
                    const SizedBox(height: 12),
                    Text(
                      '${l10n.archiveCardBirthLabel}: ${entry.yearFrom}'
                      ' • ${l10n.archiveCardDeathLabel}: ${entry.yearTo}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: AppThemes.textColorGrey,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      color: AppThemes.surfaceColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 20,
                            color: AppThemes.textColorGrey.withValues(alpha: 0.85),
                          ),
                          const SizedBox(height: 10),
                          _MetaPair(
                            label: l10n.archiveMetaBirthPlace,
                            value: entry.birthPlace,
                          ),
                          const SizedBox(height: 8),
                          _MetaPair(
                            label: l10n.archiveMetaSocialOrigin,
                            value: entry.socialOrigin,
                          ),
                          const SizedBox(height: 8),
                          _MetaPair(
                            label: l10n.archiveMetaOccupationShort,
                            value: entry.occupation,
                          ),
                        ],
                      ),
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

class _MetaPair extends StatelessWidget {
  const _MetaPair({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 42,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              fontStyle: FontStyle.italic,
              color: AppThemes.textColorGrey,
            ),
          ),
        ),
        Expanded(
          flex: 58,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.35,
              color: AppThemes.textColorPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
