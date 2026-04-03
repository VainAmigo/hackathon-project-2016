import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/domain/home_placeholder_catalog.dart';
import 'package:project_temp/features/home/presentation/l10n/home_placeholder_section_l10n.dart';

/// Светлый блок-плейсхолдер под hero.
class HomePlaceholderSection extends StatelessWidget {
  const HomePlaceholderSection({
    super.key,
    required this.sectionId,
    required this.maxContentWidth,
    required this.compact,
  });

  final HomePlaceholderSectionId sectionId;
  final double maxContentWidth;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bg = sectionId.alternateBackground
        ? AppThemes.surfaceColor
        : AppThemes.backgroundColor;
    final horizontal = compact ? 24.0 : 40.0;
    final capW = maxContentWidth.isFinite ? maxContentWidth : 640.0;

    return ColoredBox(
      color: bg,
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontal, 40, horizontal, 40),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: capW),
            child: Column(
              crossAxisAlignment: compact
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  sectionId.title(l10n),
                  textAlign: compact ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppThemes.textColorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  sectionId.subtitle(l10n),
                  textAlign: compact ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.45,
                        color: AppThemes.textColorSecondary,
                      ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 112,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppThemes.backgroundColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppThemes.textColorGrey.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    l10n.placeholderSectionBody,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppThemes.textColorGrey,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
