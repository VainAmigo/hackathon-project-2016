import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/domain/regional_map_summary.dart';

/// Подписи регионов с цветом и числом жертв.
class HomeMapLegendRow extends StatelessWidget {
  const HomeMapLegendRow({
    super.key,
    required this.counts,
    this.compact = false,
  });

  final List<RegionVictimCount> counts;
  final bool compact;

  static const _nameStyle = TextStyle(
    fontSize: 13,
    height: 1.25,
    color: AppThemes.textColorPrimary,
    fontWeight: FontWeight.w500,
  );

  static const _countStyle = TextStyle(
    fontSize: 12,
    height: 1.2,
    color: AppThemes.textColorGrey,
  );

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 12.0 : 16.0;
    return Wrap(
      spacing: gap,
      runSpacing: 10,
      children: [
        for (final r in counts)
          _LegendChip(
            color: Color(r.colorArgb),
            name: r.displayName,
            count: r.count,
            nameStyle: _nameStyle,
            countStyle: _countStyle,
          ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.color,
    required this.name,
    required this.count,
    required this.nameStyle,
    required this.countStyle,
  });

  final Color color;
  final String name;
  final int count;
  final TextStyle nameStyle;
  final TextStyle countStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: nameStyle),
            Text('$count', style: countStyle),
          ],
        ),
      ],
    );
  }
}
