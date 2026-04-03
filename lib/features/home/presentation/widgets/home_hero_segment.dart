import 'package:flutter/material.dart';

import 'package:project_temp/features/home/presentation/animation/fade_slide_in.dart';
import 'package:project_temp/features/home/presentation/widgets/ask_assistant_fake_search_bar.dart';
import 'package:project_temp/features/home/presentation/widgets/home_hero_backdrop.dart';
import 'package:project_temp/features/home/presentation/widgets/home_hero_headline.dart';

/// Первый экранный сегмент: фон + контент + кнопка «Спросите меня».
class HomeHeroSegment extends StatelessWidget {
  const HomeHeroSegment({
    super.key,
    required this.layoutW,
    required this.segmentH,
    required this.padX,
    required this.capW,
    required this.compact,
    required this.titleSize,
    required this.textAlign,
    required this.onOpenAiAssistant,
  });

  final double layoutW;
  final double segmentH;
  final double padX;
  final double capW;
  final bool compact;
  final double titleSize;
  final TextAlign textAlign;
  final VoidCallback onOpenAiAssistant;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      width: layoutW,
      height: segmentH,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(
              child: HomeHeroFallbackBackground(
                child: HomeHeroBackdrop(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SizedBox(
                    width: layoutW,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        padX,
                        compact ? 28 : 48,
                        padX,
                        12 + bottomInset,
                      ),
                      child: Align(
                        alignment: compact
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: capW),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: compact
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: SizedBox(
                              width: capW,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FadeSlideIn(
                                    duration: const Duration(
                                      milliseconds: 560,
                                    ),
                                    slideBegin: const Offset(0, 0.05),
                                    child: HomeHeroHeadline(
                                      titleSize: titleSize,
                                      textAlign: textAlign,
                                      compact: compact,
                                    ),
                                  ),
                                  SizedBox(height: compact ? 20 : 24),
                                  FadeSlideIn(
                                    delay: const Duration(milliseconds: 140),
                                    duration: const Duration(
                                      milliseconds: 520,
                                    ),
                                    slideBegin: const Offset(0, 0.07),
                                    child: AskAssistantFakeSearchBar(
                                      onPressed: onOpenAiAssistant,
                                      variant:
                                          AskAssistantSearchBarVariant.onHero,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
