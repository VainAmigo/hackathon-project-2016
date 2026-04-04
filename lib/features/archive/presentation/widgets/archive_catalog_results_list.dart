import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';
import 'package:project_temp/features/archive/presentation/archive_navigation.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_list_card.dart';

/// Список карточек каталога с разделителями и подгрузкой страниц.
class ArchiveCatalogResultsList extends StatelessWidget {
  const ArchiveCatalogResultsList({
    super.key,
    required this.entries,
    required this.emptyLabel,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 32),
    this.hasMore = false,
    this.loadingMore = false,
    this.onLoadMore,
  });

  final List<ArchiveEntry> entries;
  final String emptyLabel;
  final EdgeInsetsGeometry padding;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  static Color _dividerColor() =>
      AppThemes.textColorGrey.withValues(alpha: 0.15);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty && !loadingMore) {
      return Center(
        child: Text(
          emptyLabel,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppThemes.textColorGrey),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification n) {
        if (onLoadMore == null || !hasMore || loadingMore) {
          return false;
        }
        final m = n.metrics;
        if (m.pixels >= m.maxScrollExtent - 280) {
          onLoadMore!();
        }
        return false;
      },
      child: ListView.builder(
        padding: padding,
        itemCount: entries.length + (loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= entries.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (index > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: _dividerColor(),
                ),
              ArchiveCatalogListCard(
                entry: entries[index],
                onTap: () =>
                    pushArchiveEntryDetail(context, entries[index].id),
              ),
            ],
          );
        },
      ),
    );
  }
}
