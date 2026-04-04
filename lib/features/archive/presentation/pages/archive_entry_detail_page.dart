import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/features/archive/presentation/utils/archive_entry_source_actions.dart';

/// Страница деталей записи (пергаментный макет: шапка, сетка, текст, источник).
class ArchiveEntryDetailPage extends StatelessWidget {
  const ArchiveEntryDetailPage({super.key, required this.entry});

  final ArchiveEntry entry;

  static const _nameStyle = TextStyle(
    fontFamily: 'serif',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.15,
    color: AppThemes.textColorPrimary,
  );

  static const _bodySerif = TextStyle(
    fontFamily: 'serif',
    fontSize: 15,
    height: 1.65,
    color: AppThemes.textColorSecondary,
  );

  static const TextStyle _sectionHeading = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.15,
    height: 1.3,
    color: AppThemes.textColorPrimary,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.backgroundColor,
        foregroundColor: AppThemes.textColorPrimary,
        elevation: 0,
        title: Text(
          entry.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 44),
            child: wide
                ? _DetailWideLayout(entry: entry, l10n: l10n)
                : _DetailNarrowLayout(entry: entry, l10n: l10n),
          ),
        ),
      ),
    );
  }
}

class _DetailWideLayout extends StatelessWidget {
  const _DetailWideLayout({
    required this.entry,
    required this.l10n,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 208,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  entry.portraitAssetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: AppThemes.textColorGrey.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.person_outline,
                      size: 56,
                      color: AppThemes.textColorGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.archiveSourceHeading,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppThemes.textColorGrey,
                ),
              ),
              const SizedBox(height: 10),
              _SourceLink(entry: entry),
            ],
          ),
        ),
        const SizedBox(width: 36),
        Expanded(
          child: _DetailMainColumn(entry: entry, l10n: l10n, threeColumnGrid: true),
        ),
      ],
    );
  }
}

class _DetailNarrowLayout extends StatelessWidget {
  const _DetailNarrowLayout({
    required this.entry,
    required this.l10n,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                entry.portraitAssetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: AppThemes.textColorGrey.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.person_outline,
                    size: 56,
                    color: AppThemes.textColorGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _DetailMainColumn(entry: entry, l10n: l10n, threeColumnGrid: false),
        const SizedBox(height: 32),
        Text(
          l10n.archiveSourceHeading,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppThemes.textColorGrey,
          ),
        ),
        const SizedBox(height: 10),
        _SourceLink(entry: entry),
      ],
    );
  }
}

class _DetailMainColumn extends StatelessWidget {
  const _DetailMainColumn({
    required this.entry,
    required this.l10n,
    required this.threeColumnGrid,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;
  final bool threeColumnGrid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entry.fullName, style: ArchiveEntryDetailPage._nameStyle),
        const SizedBox(height: 12),
        Text(
          '${l10n.archiveCardBirthLabel}: ${entry.yearFrom}'
          ' • ${l10n.archiveCardDeathLabel}: ${entry.yearTo}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.65,
            color: AppThemes.textColorGrey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${l10n.archiveCaseNumberPrefix} ${entry.caseNumber}',
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppThemes.textColorPrimary,
          ),
        ),
        const SizedBox(height: 22),
        _MetaGrid(
          entry: entry,
          l10n: l10n,
          threeColumn: threeColumnGrid,
        ),
        const SizedBox(height: 28),
        Text(entry.biography, style: ArchiveEntryDetailPage._bodySerif),
        if (entry.transcriptSection != null &&
            entry.transcriptSection!.trim().isNotEmpty) ...[
          const SizedBox(height: 28),
          Text(
            l10n.archiveTranscriptHeading,
            style: ArchiveEntryDetailPage._sectionHeading,
          ),
          const SizedBox(height: 12),
          Text(
            entry.transcriptSection!,
            style: ArchiveEntryDetailPage._bodySerif,
          ),
        ],
        if (entry.verdictSection != null &&
            entry.verdictSection!.trim().isNotEmpty) ...[
          const SizedBox(height: 28),
          Text(
            l10n.archiveVerdictHeading,
            style: ArchiveEntryDetailPage._sectionHeading,
          ),
          const SizedBox(height: 12),
          Text(
            entry.verdictSection!,
            style: ArchiveEntryDetailPage._bodySerif,
          ),
        ],
        if (entry.familyConsequencesSection != null &&
            entry.familyConsequencesSection!.trim().isNotEmpty) ...[
          const SizedBox(height: 28),
          Text(
            l10n.archiveFamilyHeading,
            style: ArchiveEntryDetailPage._sectionHeading,
          ),
          const SizedBox(height: 12),
          Text(
            entry.familyConsequencesSection!,
            style: ArchiveEntryDetailPage._bodySerif,
          ),
        ],
        const SizedBox(height: 32),
        Text(
          entry.rehabFootnote,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 14,
            height: 1.5,
            fontStyle: FontStyle.italic,
            color: AppThemes.textColorSecondary,
          ),
        ),
      ],
    );
  }
}

class _MetaGrid extends StatelessWidget {
  const _MetaGrid({
    required this.entry,
    required this.l10n,
    required this.threeColumn,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;
  final bool threeColumn;

  @override
  Widget build(BuildContext context) {
    final cells = [
      _GridCell(
        label: l10n.archiveMetaBirthPlace,
        value: entry.birthPlace,
      ),
      _GridCell(
        label: l10n.archiveMetaSocialOrigin,
        value: entry.socialOrigin,
      ),
      _GridCell(
        label: l10n.archiveMetaOccupationShort,
        value: entry.occupation,
      ),
    ];

    if (!threeColumn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            cells[i],
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          Expanded(child: cells[i]),
        ],
      ],
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.35,
            color: AppThemes.textColorGrey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 15,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: AppThemes.textColorPrimary,
          ),
        ),
      ],
    );
  }
}

class _SourceLink extends StatelessWidget {
  const _SourceLink({required this.entry});

  final ArchiveEntry entry;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => openArchiveEntrySource(context, entry),
        child: Text(
          archiveSourceDisplayTitle(entry.source),
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppThemes.accentColor,
            decoration: TextDecoration.underline,
            decorationColor: AppThemes.accentColor,
          ),
        ),
      ),
    );
  }
}
