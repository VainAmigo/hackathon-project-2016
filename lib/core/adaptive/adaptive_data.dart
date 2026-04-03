import 'package:flutter/material.dart';
import 'package:project_temp/core/adaptive/adaptive_breakpoints.dart';
import 'package:project_temp/core/adaptive/adaptive_host.dart';

/// Снимок адаптивного контекста для текущего [BuildContext].
class AdaptiveData {
  const AdaptiveData({
    required this.host,
    required this.windowClass,
    required this.width,
    required this.height,
  });

  final AdaptiveHost host;
  final AdaptiveWindowClass windowClass;
  final double width;
  final double height;

  bool get isWeb => host == AdaptiveHost.web;
  bool get isNative => host == AdaptiveHost.native;

  /// Узкий макет (как один столбец на телефоне).
  bool get isCompactLayout => windowClass == AdaptiveWindowClass.compact;

  /// Достаточно ширины для боковой панели / двух колонок.
  bool get canUseSideNavigation =>
      windowClass == AdaptiveWindowClass.expanded ||
      windowClass == AdaptiveWindowClass.large;
}

extension AdaptiveContext on BuildContext {
  /// Текущие host, класс окна и размеры.
  AdaptiveData get adaptive {
    final size = MediaQuery.sizeOf(this);
    return AdaptiveData(
      host: resolveAdaptiveHost(),
      windowClass: windowClassFromWidth(size.width),
      width: size.width,
      height: size.height,
    );
  }
}
