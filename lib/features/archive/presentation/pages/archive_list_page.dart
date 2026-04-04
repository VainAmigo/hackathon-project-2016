import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_applied_query.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_repository.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';
import 'package:project_temp/features/archive/domain/archive_layout_policy.dart';
import 'package:project_temp/features/archive/presentation/mappers/archive_applied_query_mapper.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_filter_fields.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_results_list.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_filter_bottom_sheet.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Полный каталог записей с фильтрацией (поля как на ручной форме добавления).
class ArchiveListPage extends StatefulWidget {
  const ArchiveListPage({super.key});

  @override
  State<ArchiveListPage> createState() => _ArchiveListPageState();
}

class _ArchiveListPageState extends State<ArchiveListPage> {
  List<ArchiveEntry> _all = [];
  bool _loading = true;
  ArchiveCatalogAppliedQuery _applied = ArchiveCatalogAppliedQuery.empty;

  final _fullName = TextEditingController();
  final _accusation = TextEditingController();
  final _yearFrom = TextEditingController();
  final _yearTo = TextEditingController();
  final _punishment = TextEditingController();
  final _region = TextEditingController();
  final _punishmentDate = TextEditingController();
  final _occupation = TextEditingController();
  final _rehabDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _submitFilter() {
    setState(() {
      _applied = archiveAppliedQueryFromControllers(
        fullName: _fullName,
        accusation: _accusation,
        yearFrom: _yearFrom,
        yearTo: _yearTo,
        punishment: _punishment,
        region: _region,
        punishmentDate: _punishmentDate,
        occupation: _occupation,
        rehabDate: _rehabDate,
      );
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _openFilterBottomSheet(BuildContext context) {
    final l10n = context.l10n;
    return showArchiveFilterBottomSheet(
      context: context,
      l10n: l10n,
      fullName: _fullName,
      accusation: _accusation,
      yearFrom: _yearFrom,
      yearTo: _yearTo,
      punishment: _punishment,
      region: _region,
      punishmentDate: _punishmentDate,
      occupation: _occupation,
      rehabDate: _rehabDate,
      onSubmit: _submitFilter,
      onClear: _clearFilters,
    );
  }

  Future<void> _load() async {
    final list = await sl<ArchiveCatalogRepository>().loadEntries();
    if (!mounted) return;
    setState(() {
      _all = list;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _fullName.dispose();
    _accusation.dispose();
    _yearFrom.dispose();
    _yearTo.dispose();
    _punishment.dispose();
    _region.dispose();
    _punishmentDate.dispose();
    _occupation.dispose();
    _rehabDate.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _fullName.clear();
    _accusation.clear();
    _yearFrom.clear();
    _yearTo.clear();
    _punishment.clear();
    _region.clear();
    _punishmentDate.clear();
    _occupation.clear();
    _rehabDate.clear();
    setState(() => _applied = ArchiveCatalogAppliedQuery.empty);
  }

  List<ArchiveEntry> get _filtered =>
      _all.where(_applied.matches).toList(growable: false);

  Widget _filterForm(AppLocalizations l10n, {required bool includeTitle}) {
    return ArchiveCatalogFilterFields(
      l10n: l10n,
      includeTitle: includeTitle,
      fullName: _fullName,
      accusation: _accusation,
      yearFrom: _yearFrom,
      yearTo: _yearTo,
      punishment: _punishment,
      region: _region,
      punishmentDate: _punishmentDate,
      occupation: _occupation,
      rehabDate: _rehabDate,
      onSubmit: _submitFilter,
      onClear: _clearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wide = MediaQuery.sizeOf(context).width >=
        ArchiveLayoutPolicy.catalogWideMinWidth;

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.backgroundColor,
        foregroundColor: AppThemes.textColorPrimary,
        elevation: 0,
        title: Text(
          l10n.archiveViewFullArchive,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (!_loading && !wide)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: l10n.archiveOpenFilters,
              onPressed: () => _openFilterBottomSheet(context),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 300,
                      child: ColoredBox(
                        color: AppThemes.surfaceColor,
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          child: _filterForm(l10n, includeTitle: true),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color:
                          AppThemes.textColorGrey.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: ArchiveCatalogResultsList(
                        entries: _filtered,
                        emptyLabel: l10n.archiveCatalogEmpty,
                      ),
                    ),
                  ],
                )
              : ArchiveCatalogResultsList(
                  entries: _filtered,
                  emptyLabel: l10n.archiveCatalogEmpty,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                ),
    );
  }
}
