import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';

/// Заголовок и подзаголовок hero (поверх тёмного фона).
class HomeHeroHeadline extends StatelessWidget {
  const HomeHeroHeadline({
    super.key,
    required this.titleSize,
    required this.textAlign,
    required this.compact,
  });

  final double titleSize;
  final TextAlign textAlign;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final serif = TextStyle(
      fontFamily: 'Georgia',
      color: AppThemes.backgroundColor,
      height: 1.05,
    );

    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      letterSpacing: 4,
      fontWeight: FontWeight.w400,
      color: AppThemes.textColorGrey,
    );

    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: AppThemes.surfaceColor,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.homeHeroEyebrow, textAlign: textAlign, style: labelStyle),
        SizedBox(height: compact ? 14 : 20),
        Text.rich(
          TextSpan(
            style: serif.copyWith(
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(text: '${l10n.homeHeroTitleLine1}\n'),
              TextSpan(
                style: serif.copyWith(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
                children: [
                  TextSpan(text: l10n.homeHeroTitleThe),
                  TextSpan(
                    text: l10n.homeHeroTitleSilence,
                    style: serif.copyWith(
                      fontSize: titleSize * 0.92,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          textAlign: textAlign,
        ),
        SizedBox(height: compact ? 20 : 28),
        Text(
          l10n.homeLandingSubtitle,
          textAlign: textAlign,
          style: bodyStyle?.copyWith(fontSize: compact ? 15 : 16),
        ),
      ],
    );
  }
}
