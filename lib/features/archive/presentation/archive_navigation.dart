import 'package:flutter/material.dart';

import 'package:project_temp/features/archive/domain/archive_entry.dart';
import 'package:project_temp/features/archive/presentation/pages/archive_entry_detail_page.dart';
import 'package:project_temp/features/archive/presentation/pages/archive_list_page.dart';

void pushArchiveEntryDetail(BuildContext context, ArchiveEntry entry) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => ArchiveEntryDetailPage(entry: entry),
    ),
  );
}

void pushArchiveCatalog(BuildContext context) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(builder: (_) => const ArchiveListPage()),
  );
}
