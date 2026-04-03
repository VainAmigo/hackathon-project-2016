import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/home.dart';

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
    final serif = TextStyle(
      fontFamily: 'Georgia',
      color: AppThemes.homeHeroTextHeadline,
      height: 1.05,
    );

    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 4,
          fontWeight: FontWeight.w400,
          color: AppThemes.homeHeroTextEyebrow,
        );

    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: AppThemes.homeHeroTextBody,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          HomeLandingContent.eyebrow,
          textAlign: textAlign,
          style: labelStyle,
        ),
        SizedBox(height: compact ? 14 : 20),
        Text.rich(
          TextSpan(
            style: serif.copyWith(
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
            ),
            children: [
              const TextSpan(text: 'Voices from\n'),
              TextSpan(
                style: serif.copyWith(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
                children: [
                  const TextSpan(text: 'the '),
                  TextSpan(
                    text: 'Silence',
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
          HomeLandingContent.subtitle,
          textAlign: textAlign,
          style: bodyStyle?.copyWith(
            fontSize: compact ? 15 : 16,
          ),
        ),
      ],
    );
  }
}
