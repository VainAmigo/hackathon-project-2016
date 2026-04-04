import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/domain/regional_map_summary.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Вертикальный блок карточек сводной статистики.
class HomeMapSummaryPanel extends StatelessWidget {
  const HomeMapSummaryPanel({
    super.key,
    required this.summary,
    required this.l10n,
  });

  final RegionalMapSummary summary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryCard(
          value: '${summary.totalVictims}',
          label: l10n.homeMapSummaryTotalLabel,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          value: '${summary.regionCount}',
          label: l10n.homeMapSummaryRegionsLabel,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          value: summary.averageVictimsPerRegion.toStringAsFixed(1),
          label: l10n.homeMapSummaryAvgLabel,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppThemes.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemes.textColorGrey.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.05,
                color: AppThemes.textColorPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Container(width: 40, height: 3, color: AppThemes.accentColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                height: 1.3,
                color: AppThemes.textColorSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
