import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_repository.dart';
import 'package:project_temp/features/archive/domain/archive_layout_policy.dart';
import 'package:project_temp/features/archive/presentation/mappers/archive_applied_query_mapper.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_filter_fields.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_results_list.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_filter_bottom_sheet.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// Полный каталог записей с фильтрацией (поля как на ручной форме добавления).
class ArchiveListPage extends StatefulWidget {
  const ArchiveListPage({super.key});

  @override
  State<ArchiveListPage> createState() => _ArchiveListPageState();
}

class _ArchiveListPageState extends State<ArchiveListPage> {
  static const _pageSize = 20;

  final List<ArchiveEntry> _items = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _lastPage = true;
  int _pageIndex = 0;
  String? _error;
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
    _fetchFirstPage();
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
    _fetchFirstPage();
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

  Future<void> _fetchFirstPage() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final q = _applied.toPersonsListQuery(page: 0, size: _pageSize);
    final r = await sl<ArchiveCatalogRepository>().fetchPersons(q);
    if (!mounted) return;
    r.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
        _items.clear();
        _lastPage = true;
        _pageIndex = 0;
      }),
      (page) => setState(() {
        _loading = false;
        _items
          ..clear()
          ..addAll(page.content);
        _lastPage = page.last;
        _pageIndex = page.number;
      }),
    );
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _lastPage || _loading) return;
    setState(() => _loadingMore = true);
    final q =
        _applied.toPersonsListQuery(page: _pageIndex + 1, size: _pageSize);
    final r = await sl<ArchiveCatalogRepository>().fetchPersons(q);
    if (!mounted) return;
    r.fold(
      (_) => setState(() => _loadingMore = false),
      (page) => setState(() {
        _loadingMore = false;
        _items.addAll(page.content);
        _lastPage = page.last;
        _pageIndex = page.number;
      }),
    );
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
    _fetchFirstPage();
  }

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

  Widget _body(AppLocalizations l10n, {required bool wide}) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppThemes.textColorSecondary),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Повторить'),
                onPressed: _fetchFirstPage,
              ),
            ],
          ),
        ),
      );
    }

    final list = ArchiveCatalogResultsList(
      entries: _items,
      emptyLabel: l10n.archiveCatalogEmpty,
      hasMore: !_lastPage,
      loadingMore: _loadingMore,
      onLoadMore: _loadMore,
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 300,
            child: ColoredBox(
              color: AppThemes.surfaceColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: _filterForm(l10n, includeTitle: true),
              ),
            ),
          ),
          Container(
            width: 1,
            color: AppThemes.textColorGrey.withValues(alpha: 0.2),
          ),
          Expanded(child: list),
        ],
      );
    }

    return ArchiveCatalogResultsList(
      entries: _items,
      emptyLabel: l10n.archiveCatalogEmpty,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      hasMore: !_lastPage,
      loadingMore: _loadingMore,
      onLoadMore: _loadMore,
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
      body: _body(l10n, wide: wide),
    );
  }
}
