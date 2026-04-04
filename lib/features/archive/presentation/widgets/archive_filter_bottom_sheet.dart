import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_catalog_filter_fields.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Нижний лист с формой фильтра каталога.
Future<void> showArchiveFilterBottomSheet({
  required BuildContext context,
  required AppLocalizations l10n,
  required TextEditingController fullName,
  required TextEditingController accusation,
  required TextEditingController yearFrom,
  required TextEditingController yearTo,
  required TextEditingController punishment,
  required TextEditingController region,
  required TextEditingController punishmentDate,
  required TextEditingController occupation,
  required TextEditingController rehabDate,
  required VoidCallback onSubmit,
  required VoidCallback onClear,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.38,
          maxChildSize: 0.96,
          builder: (ctx, scrollController) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: AppThemes.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppThemes.textColorGrey.withValues(
                          alpha: 0.45,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 4, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.archiveFilterTitle,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppThemes.textColorPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close),
                          color: AppThemes.textColorPrimary,
                          tooltip:
                              MaterialLocalizations.of(ctx).closeButtonTooltip,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      child: ArchiveCatalogFilterFields(
                        l10n: l10n,
                        includeTitle: false,
                        fullName: fullName,
                        accusation: accusation,
                        yearFrom: yearFrom,
                        yearTo: yearTo,
                        punishment: punishment,
                        region: region,
                        punishmentDate: punishmentDate,
                        occupation: occupation,
                        rehabDate: rehabDate,
                        onSubmit: () {
                          onSubmit();
                          Navigator.of(ctx).pop();
                        },
                        onClear: onClear,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
