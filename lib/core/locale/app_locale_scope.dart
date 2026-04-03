import 'package:flutter/widgets.dart';
import 'package:project_temp/core/locale/app_locale_controller.dart';

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    super.key,
    required AppLocaleController super.notifier,
    required super.child,
  });

  static AppLocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope не найден в дереве виджетов');
    return scope!.notifier!;
  }

  static AppLocaleController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope не найден в дереве виджетов');
    return scope!.notifier!;
  }
}
