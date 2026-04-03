import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';

/// Кнопка, визуально похожая на поле поиска.
class AskAssistantFakeSearchBar extends StatelessWidget {
  const AskAssistantFakeSearchBar({
    super.key,
    required this.onPressed,
    this.variant = AskAssistantSearchBarVariant.onHero,
  });

  final VoidCallback onPressed;
  final AskAssistantSearchBarVariant variant;

  @override
  Widget build(BuildContext context) {
    final (Color fill, Color border, Color fg) = switch (variant) {
      AskAssistantSearchBarVariant.onHero => (
          AppThemes.homeHeroSearchFill,
          AppThemes.homeHeroSearchBorder,
          AppThemes.homeHeroSearchForeground,
        ),
      AskAssistantSearchBarVariant.light => (
          AppThemes.backgroundColor,
          AppThemes.textColorGrey.withValues(alpha: 0.45),
          AppThemes.textColorSecondary,
        ),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(2),
        child: Ink(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.search, size: 22, color: fg),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Спросите меня',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: fg,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
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

enum AskAssistantSearchBarVariant { onHero, light }
