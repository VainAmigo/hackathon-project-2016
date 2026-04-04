import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';
import 'package:project_temp/features/archive/presentation/archive_navigation.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_list_card.dart';

/// Список карточек каталога с разделителями.
class ArchiveCatalogResultsList extends StatelessWidget {
  const ArchiveCatalogResultsList({
    super.key,
    required this.entries,
    required this.emptyLabel,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 32),
  });

  final List<ArchiveEntry> entries;
  final String emptyLabel;
  final EdgeInsetsGeometry padding;

  static Color _dividerColor() =>
      AppThemes.textColorGrey.withValues(alpha: 0.15);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppThemes.textColorGrey),
        ),
      );
    }
    return ListView.separated(
      padding: padding,
      itemCount: entries.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        thickness: 1,
        color: _dividerColor(),
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ArchiveCatalogListCard(
          entry: entry,
          onTap: () => pushArchiveEntryDetail(context, entry),
        );
      },
    );
  }
}
