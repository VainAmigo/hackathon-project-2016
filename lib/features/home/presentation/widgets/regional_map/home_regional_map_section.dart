import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/features/home/domain/regional_victims_repository.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/home_interactive_regional_map.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/home_map_legend_row.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/home_map_summary_panel.dart';
import 'package:project_temp/features/home/presentation/localization/map_region_l10n.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/home_region_victims_sheet.dart';

/// Нижний блок главной: карта, затем легенда (маркеры), затем сводка.
class HomeRegionalMapSection extends StatefulWidget {
  const HomeRegionalMapSection({
    super.key,
    required this.maxContentWidth,
    required this.compact,
  });

  final double maxContentWidth;
  final bool compact;

  @override
  State<HomeRegionalMapSection> createState() => _HomeRegionalMapSectionState();
}

class _HomeRegionalMapSectionState extends State<HomeRegionalMapSection> {
  MapRegionId? _highlighted;

  static const _titleStyle = TextStyle(
    fontFamily: 'serif',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.05,
    color: AppThemes.textColorPrimary,
  );

  Future<void> _openRegion(BuildContext context, MapRegionId id) async {
    setState(() => _highlighted = id);
    final repo = sl<RegionalVictimsRepository>();
    final victims = repo.victimsFor(id);
    await showHomeRegionVictimsSheet(
      context: context,
      regionDisplayName: context.l10n.mapRegionLabel(id),
      victims: victims,
    );
    if (mounted) setState(() => _highlighted = null);
  }

  @override
  Widget build(BuildContext context) {
    final repo = sl<RegionalVictimsRepository>();
    final l10n = context.l10n;
    final horizontal = widget.compact ? 24.0 : 40.0;
    final capW = widget.maxContentWidth.isFinite ? widget.maxContentWidth : 640.0;

    return ColoredBox(
      color: AppThemes.surfaceColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontal, 44, horizontal, 40),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: capW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.homeMapSectionTitle, style: _titleStyle),
                const SizedBox(height: 8),
                Container(
                  width: 96,
                  height: 4,
                  color: AppThemes.accentColor,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.homeMapSectionSubtitle,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppThemes.textColorSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                if (widget.compact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeInteractiveRegionalMap(
                        highlighted: _highlighted,
                        onRegionTap: (id) => _openRegion(context, id),
                      ),
                      const SizedBox(height: 20),
                      HomeMapLegendRow(
                        counts: repo.regionCounts,
                        compact: true,
                      ),
                      const SizedBox(height: 20),
                      HomeMapSummaryPanel(summary: repo.summary, l10n: l10n),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: HomeInteractiveRegionalMap(
                          highlighted: _highlighted,
                          onRegionTap: (id) => _openRegion(context, id),
                        ),
                      ),
                      const SizedBox(width: 28),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HomeMapLegendRow(
                              counts: repo.regionCounts,
                              compact: false,
                            ),
                            const SizedBox(height: 20),
                            HomeMapSummaryPanel(
                              summary: repo.summary,
                              l10n: l10n,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
