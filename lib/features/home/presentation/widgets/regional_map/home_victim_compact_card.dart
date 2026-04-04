import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/domain/victim_record.dart';
import 'package:project_temp/l10n/app_localizations.dart';

class HomeVictimCompactCard extends StatelessWidget {
  const HomeVictimCompactCard({
    super.key,
    required this.victim,
    required this.l10n,
    required this.formatDate,
  });

  final VictimRecord victim;
  final AppLocalizations l10n;
  final String Function(DateTime d) formatDate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppThemes.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppThemes.textColorGrey.withValues(alpha: 0.14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              victim.fullName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: AppThemes.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _DateLine(
              label: l10n.homeMapBirthShort,
              value: formatDate(victim.birthDate),
            ),
            const SizedBox(height: 4),
            _DateLine(
              label: l10n.homeMapDeathShort,
              value: formatDate(victim.deathDate),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateLine extends StatelessWidget {
  const _DateLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 13,
          height: 1.35,
          color: AppThemes.textColorSecondary,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: AppThemes.textColorGrey),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
