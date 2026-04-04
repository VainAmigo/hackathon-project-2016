import 'package:flutter/material.dart';

import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Поля фильтра каталога (те же подписи, что ручная форма добавления записи).
class ArchiveCatalogFilterFields extends StatelessWidget {
  const ArchiveCatalogFilterFields({
    super.key,
    required this.l10n,
    this.includeTitle = true,
    required this.fullName,
    required this.accusation,
    required this.yearFrom,
    required this.yearTo,
    required this.punishment,
    required this.region,
    required this.punishmentDate,
    required this.occupation,
    required this.rehabDate,
    required this.onSubmit,
    required this.onClear,
  });

  final AppLocalizations l10n;
  final bool includeTitle;
  final TextEditingController fullName;
  final TextEditingController accusation;
  final TextEditingController yearFrom;
  final TextEditingController yearTo;
  final TextEditingController punishment;
  final TextEditingController region;
  final TextEditingController punishmentDate;
  final TextEditingController occupation;
  final TextEditingController rehabDate;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (includeTitle) ...[
          Text(
            l10n.archiveFilterTitle,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppThemes.textColorPrimary,
            ),
          ),
          const SizedBox(height: 20),
        ],
        CustomTextFormField(
          controller: fullName,
          label: l10n.addEntryFieldFullName,
          hintText: l10n.addEntryFieldFullNameHint,
        ),
        CustomTextFormField(
          controller: accusation,
          label: l10n.addEntryFieldAccusation,
        ),
        YearRangeFormRow(
          l10n: l10n,
          yearFrom: yearFrom,
          yearTo: yearTo,
          paddingTop: 8,
        ),
        CustomTextFormField(
          controller: punishment,
          label: l10n.addEntryFieldPunishment,
        ),
        CustomTextFormField(
          controller: region,
          label: l10n.addEntryFieldRegion,
          hintText: l10n.addEntryFieldRegionHint,
        ),
        CustomTextFormField(
          controller: punishmentDate,
          label: l10n.addEntryFieldPunishmentDate,
        ),
        CustomTextFormField(
          controller: occupation,
          label: l10n.addEntryFieldOccupation,
        ),
        CustomTextFormField(
          controller: rehabDate,
          label: l10n.addEntryFieldRehabDate,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          text: l10n.archiveFilterSubmitRequest,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onClear,
            child: Text(l10n.archiveFilterClear),
          ),
        ),
      ],
    );
  }
}
