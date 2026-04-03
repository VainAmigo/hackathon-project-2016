import 'package:project_temp/core/adaptive/adaptive_breakpoints.dart';

/// Правила типографики и ширины контента для лендинга (domain / без UI).
abstract final class HomeLayoutPolicy {
  static double heroTitleSize(AdaptiveWindowClass windowClass) {
    switch (windowClass) {
      case AdaptiveWindowClass.compact:
        return 34;
      case AdaptiveWindowClass.medium:
        return 56;
      case AdaptiveWindowClass.expanded:
      case AdaptiveWindowClass.large:
        return 96;
    }
  }

  static double maxContentWidth({
    required bool isCompactLayout,
    required bool canUseSideNavigation,
  }) {
    if (isCompactLayout) return double.infinity;
    if (canUseSideNavigation) return 640;
    return 520;
  }
}
