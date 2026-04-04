import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/presentation/widgets/home_archive_section.dart';
import 'package:project_temp/features/home/domain/home_layout_policy.dart';
import 'package:project_temp/features/home/presentation/widgets/home_hero_segment.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/home_regional_map_section.dart';

/// Скролл главной вкладки: hero + материалы архива.
class HomeLandingBody extends StatelessWidget {
  const HomeLandingBody({super.key, required this.onOpenAiAssistant});

  final VoidCallback onOpenAiAssistant;

  @override
  Widget build(BuildContext context) {
    final a = context.adaptive;
    final compact = a.isCompactLayout;
    final titleSize = HomeLayoutPolicy.heroTitleSize(a.windowClass);
    final maxW = HomeLayoutPolicy.maxContentWidth(
      isCompactLayout: a.isCompactLayout,
      canUseSideNavigation: a.canUseSideNavigation,
    );
    final textAlign = compact ? TextAlign.left : TextAlign.center;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewH = MediaQuery.sizeOf(context).height;
        final segmentH =
            constraints.hasBoundedHeight &&
                constraints.maxHeight.isFinite &&
                constraints.maxHeight > 0
            ? constraints.maxHeight
            : viewH;

        final padX = compact ? 24.0 : 40.0;
        final layoutW =
            (constraints.maxWidth.isFinite && constraints.maxWidth > 0)
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final innerMaxW = (layoutW - 2 * padX).clamp(1.0, double.infinity);
        final capW = maxW.isFinite ? maxW.clamp(1.0, innerMaxW) : innerMaxW;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeroSegment(
                layoutW: layoutW,
                segmentH: segmentH,
                padX: padX,
                capW: capW,
                compact: compact,
                titleSize: titleSize,
                textAlign: textAlign,
                onOpenAiAssistant: onOpenAiAssistant,
              ),
              HomeArchiveSection(maxContentWidth: maxW, compact: compact),
              HomeRegionalMapSection(maxContentWidth: maxW, compact: compact),
              SizedBox(height: 24 + MediaQuery.paddingOf(context).bottom),
            ],
          ),
        );
      },
    );
  }
}
