/// Класс ширины окна по [Material Design 3](https://m3.material.io/foundations/layout/applying-layout/window-size-classes).
enum AdaptiveWindowClass {
  /// &lt; 600 dp — телефон в портрете, узкое окно.
  compact,

  /// 600–839 dp — планшет, телефон в ландшафте.
  medium,

  /// 840–1199 dp — средний дисплей, боковая навигация.
  expanded,

  /// ≥ 1200 dp — широкий экран, несколько колонок.
  large,
}

AdaptiveWindowClass windowClassFromWidth(double width) {
  if (width < 600) return AdaptiveWindowClass.compact;
  if (width < 840) return AdaptiveWindowClass.medium;
  if (width < 1200) return AdaptiveWindowClass.expanded;
  return AdaptiveWindowClass.large;
}
