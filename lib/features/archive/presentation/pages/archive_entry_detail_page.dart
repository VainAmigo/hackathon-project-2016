import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_detail_documents_block.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_entry_detail_language_bar.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_entry_portrait.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_moderator_verify_section.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_person_audio_section.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// Детали записи: загрузка GET /api/v1/persons/{id}.
class ArchiveEntryDetailPage extends StatefulWidget {
  const ArchiveEntryDetailPage({super.key, required this.personId});

  final String personId;

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
  State<ArchiveEntryDetailPage> createState() => _ArchiveEntryDetailPageState();
}

class _ArchiveEntryDetailPageState extends State<ArchiveEntryDetailPage> {
  late Future<Either<Failure, ArchiveEntry>> _future;
  late AppLanguageCode _recordLanguage;
  var _bootstrapped = false;

  Future<Either<Failure, ArchiveEntry>> _fetchPerson() {
    return sl<PersonsRepository>().getPerson(
      widget.personId,
      languageCode: _recordLanguage.name,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;
    _recordLanguage = AppLocaleScope.of(context).code;
    _future = _fetchPerson();
  }

  void _onRecordLanguage(AppLanguageCode code) {
    if (_recordLanguage == code) return;
    setState(() {
      _recordLanguage = code;
      _future = _fetchPerson();
    });
  }

  void _retry() {
    setState(() {
      _future = _fetchPerson();
    });
  }

  void _reloadPerson() {
    setState(() {
      _future = _fetchPerson();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return FutureBuilder<Either<Failure, ArchiveEntry>>(
      future: _future,
      builder: (context, snap) {
        final title = _resolveTitle(l10n, snap);
        Widget body;
        if (snap.connectionState == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else {
          final data = snap.data;
          if (data == null) {
            body = _ErrorBody(message: l10n.archiveCatalogEmpty, onRetry: _retry);
          } else {
            body = data.fold(
              (f) => _ErrorBody(message: f.message, onRetry: _retry),
              (entry) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 44),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ArchiveEntryDetailLanguageBar(
                            l10n: l10n,
                            selected: _recordLanguage,
                            onSelected: _onRecordLanguage,
                          ),
                          const SizedBox(height: 20),
                          wide
                              ? _DetailWideLayout(
                                  entry: entry,
                                  l10n: l10n,
                                  onModerationComplete: _reloadPerson,
                                )
                              : _DetailNarrowLayout(
                                  entry: entry,
                                  l10n: l10n,
                                  onModerationComplete: _reloadPerson,
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }

        return Scaffold(
          backgroundColor: AppThemes.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppThemes.backgroundColor,
            foregroundColor: AppThemes.textColorPrimary,
            elevation: 0,
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: body,
        );
      },
    );
  }

  static String _resolveTitle(
    AppLocalizations l10n,
    AsyncSnapshot<Either<Failure, ArchiveEntry>> snap,
  ) {
    if (snap.connectionState == ConnectionState.waiting) {
      return l10n.navArchive;
    }
    final data = snap.data;
    if (data == null) return l10n.navArchive;
    return data.fold((_) => l10n.navArchive, (e) => e.fullName);
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppThemes.textColorSecondary),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Повторить'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailWideLayout extends StatelessWidget {
  const _DetailWideLayout({
    required this.entry,
    required this.l10n,
    required this.onModerationComplete,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;
  final VoidCallback onModerationComplete;

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
                child: ArchiveEntryPortrait(
                  entry: entry,
                  width: 208,
                  height: 208,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),
              ArchivePersonAudioSection(personId: entry.id, l10n: l10n),
              const SizedBox(height: 24),
              ArchiveModeratorVerifySection(
                personId: entry.id,
                l10n: l10n,
                onSuccess: onModerationComplete,
              ),
              const SizedBox(height: 24),
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
              ArchiveDetailDocumentsBlock(entry: entry, l10n: l10n),
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
    required this.onModerationComplete,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;
  final VoidCallback onModerationComplete;

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
              child: ArchiveEntryPortrait(
                entry: entry,
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _DetailMainColumn(entry: entry, l10n: l10n, threeColumnGrid: false),
        const SizedBox(height: 32),
        ArchivePersonAudioSection(personId: entry.id, l10n: l10n),
        const SizedBox(height: 24),
        ArchiveModeratorVerifySection(
          personId: entry.id,
          l10n: l10n,
          onSuccess: onModerationComplete,
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
        ArchiveDetailDocumentsBlock(entry: entry, l10n: l10n),
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

  static bool _has(String s) => s.trim().isNotEmpty && s.trim() != '—';

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
        _DetailMetaGrid(
          entry: entry,
          l10n: l10n,
          threeColumn: threeColumnGrid,
        ),
        if (_has(entry.arrestDate) ||
            _has(entry.punishmentDate) ||
            _has(entry.rehabDate)) ...[
          const SizedBox(height: 20),
          _DateMetaBlock(entry: entry, l10n: l10n),
        ],
        if (_has(entry.accusation)) ...[
          const SizedBox(height: 28),
          Text(
            l10n.addEntryFieldAccusation,
            style: ArchiveEntryDetailPage._sectionHeading,
          ),
          const SizedBox(height: 12),
          Text(entry.accusation, style: ArchiveEntryDetailPage._bodySerif),
        ],
        if (_has(entry.biography)) ...[
          const SizedBox(height: 28),
          Text(entry.biography, style: ArchiveEntryDetailPage._bodySerif),
        ],
        if (entry.verdictSection != null && _has(entry.verdictSection!)) ...[
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
      ],
    );
  }
}

class _DateMetaBlock extends StatelessWidget {
  const _DateMetaBlock({required this.entry, required this.l10n});

  final ArchiveEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entry.arrestDate.trim().isNotEmpty)
          _DateRow(label: l10n.archiveMetaArrestDate, value: entry.arrestDate),
        if (entry.arrestDate.trim().isNotEmpty &&
            entry.punishmentDate.trim().isNotEmpty)
          const SizedBox(height: 10),
        if (entry.punishmentDate.trim().isNotEmpty)
          _DateRow(
            label: l10n.addEntryFieldPunishmentDate,
            value: entry.punishmentDate,
          ),
        if (entry.punishmentDate.trim().isNotEmpty &&
            entry.rehabDate.trim().isNotEmpty)
          const SizedBox(height: 10),
        if (entry.rehabDate.trim().isNotEmpty)
          _DateRow(
            label: l10n.addEntryFieldRehabDate,
            value: entry.rehabDate,
          ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          color: AppThemes.textColorSecondary,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppThemes.textColorGrey,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              color: AppThemes.textColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailMetaGrid extends StatelessWidget {
  const _DetailMetaGrid({
    required this.entry,
    required this.l10n,
    required this.threeColumn,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;
  final bool threeColumn;

  static bool _use(String s) => s.trim().isNotEmpty && s.trim() != '—';

  @override
  Widget build(BuildContext context) {
    final cells = <_GridCell>[];
    if (_use(entry.birthPlace)) {
      cells.add(_GridCell(label: l10n.archiveMetaBirthPlace, value: entry.birthPlace));
    }
    if (_use(entry.region)) {
      cells.add(_GridCell(label: l10n.addEntryFieldRegion, value: entry.region));
    }
    if (_use(entry.district)) {
      cells.add(_GridCell(label: l10n.archiveMetaDistrict, value: entry.district));
    }
    if (_use(entry.deathPlace)) {
      cells.add(
        _GridCell(label: l10n.archiveMetaDeathPlace, value: entry.deathPlace),
      );
    }
    if (_use(entry.occupation)) {
      cells.add(
        _GridCell(label: l10n.archiveMetaOccupationShort, value: entry.occupation),
      );
    }

    if (cells.isEmpty) {
      return const SizedBox.shrink();
    }

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

    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 520) {
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
        final rows = <Widget>[];
        for (var i = 0; i < cells.length; i += 3) {
          final chunk = cells.sublist(
            i,
            i + 3 > cells.length ? cells.length : i + 3,
          );
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var j = 0; j < chunk.length; j++) ...[
                  if (j > 0) const SizedBox(width: 16),
                  Expanded(child: chunk[j]),
                ],
              ],
            ),
          );
          if (i + 3 < cells.length) {
            rows.add(const SizedBox(height: 16));
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
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
