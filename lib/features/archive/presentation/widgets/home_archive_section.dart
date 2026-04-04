import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_repository.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';
import 'package:project_temp/features/archive/presentation/archive_navigation.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_entry_card.dart';

/// Секция архива под hero: заголовок макета + карточки.
class HomeArchiveSection extends StatelessWidget {
  const HomeArchiveSection({
    super.key,
    required this.maxContentWidth,
    required this.compact,
  });

  final double maxContentWidth;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final horizontal = compact ? 24.0 : 40.0;
    final capW = maxContentWidth.isFinite ? maxContentWidth : 640.0;

    return ColoredBox(
      color: AppThemes.backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontal, 40, horizontal, 48),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: capW),
            child: FutureBuilder<List<ArchiveEntry>>(
              future: sl<ArchiveCatalogRepository>().loadEntries(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snap.hasError || snap.data == null || snap.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                final entries = snap.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionHeader(
                      compact: compact,
                      onViewFullArchive: () => pushArchiveCatalog(context),
                    ),
                    const SizedBox(height: 28),
                    for (var i = 0; i < entries.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppThemes.textColorGrey.withValues(alpha: 0.18),
                        ),
                      ArchiveEntryCard(
                        entry: entries[i],
                        onTap: () =>
                            pushArchiveEntryDetail(context, entries[i]),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.compact,
    required this.onViewFullArchive,
  });

  final bool compact;
  final VoidCallback onViewFullArchive;

  static const _titleStyle = TextStyle(
    fontFamily: 'serif',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.05,
    color: AppThemes.textColorPrimary,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 0,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.archiveSectionTitleLead, style: _titleStyle),
                  const SizedBox(height: 8),
                  Container(
                    width: 96,
                    height: 4,
                    color: AppThemes.accentColor,
                  ),
                ],
              ),
              Text(l10n.archiveSectionTitleTail, style: _titleStyle),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onViewFullArchive,
            style: TextButton.styleFrom(
              foregroundColor: AppThemes.textColorGrey,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.archiveViewFullArchive,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.85,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 0,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.archiveSectionTitleLead, style: _titleStyle),
                  const SizedBox(height: 8),
                  Container(
                    width: 96,
                    height: 4,
                    color: AppThemes.accentColor,
                  ),
                ],
              ),
              Text(l10n.archiveSectionTitleTail, style: _titleStyle),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: TextButton(
            onPressed: onViewFullArchive,
            style: TextButton.styleFrom(
              foregroundColor: AppThemes.textColorGrey,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.archiveViewFullArchive,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.85,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
