import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/domain/victim_record.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/home_victim_compact_card.dart';

Future<void> showHomeRegionVictimsSheet({
  required BuildContext context,
  required String regionDisplayName,
  required List<VictimRecord> victims,
}) async {
  final l10n = context.l10n;
  final locale = MaterialLocalizations.of(context);

  String formatDate(DateTime d) {
    return locale.formatFullDate(d);
  }

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppThemes.surfaceColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (ctx) {
      final bottom = MediaQuery.paddingOf(ctx).bottom;
      final maxListH = MediaQuery.sizeOf(ctx).height * 0.58;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppThemes.textColorGrey.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.homeMapVictimsSheetTitle(regionDisplayName),
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: AppThemes.textColorPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(width: 56, height: 3, color: AppThemes.accentColor),
              const SizedBox(height: 18),
              if (victims.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.homeMapEmptyVictims,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppThemes.textColorSecondary,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: maxListH,
                  child: ListView.separated(
                    itemCount: victims.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      return HomeVictimCompactCard(
                        victim: victims[i],
                        l10n: l10n,
                        formatDate: formatDate,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
