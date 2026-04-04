import 'package:flutter/material.dart';

import 'package:project_temp/components/form/custom_text_form_field.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Два поля «год с» / «год по» с общей подписью (как на форме добавления записи).
class YearRangeFormRow extends StatelessWidget {
  const YearRangeFormRow({
    super.key,
    required this.l10n,
    required this.yearFrom,
    required this.yearTo,
    this.paddingTop = 16,
  });

  final AppLocalizations l10n;
  final TextEditingController yearFrom;
  final TextEditingController yearTo;
  final double paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.addEntryFieldLifeYears,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppThemes.textColorSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: yearFrom,
                  hintText: l10n.addEntryYearFrom,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: Text(
                  '—',
                  style: TextStyle(color: AppThemes.textColorGrey),
                ),
              ),
              Expanded(
                child: CustomTextFormField(
                  controller: yearTo,
                  hintText: l10n.addEntryYearTo,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
