import 'package:flutter/widgets.dart';
import 'package:project_temp/features/auth/application/auth_session_controller.dart';

class AuthSessionScope extends InheritedNotifier<AuthSessionController> {
  const AuthSessionScope({
    super.key,
    required AuthSessionController super.notifier,
    required super.child,
  });

  static AuthSessionController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthSessionScope>();
    assert(scope != null, 'AuthSessionScope не найден в дереве виджетов');
    return scope!.notifier!;
  }

  /// Без подписки на обновления (после `await` и проверки `context.mounted`).
  static AuthSessionController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AuthSessionScope>();
    assert(scope != null, 'AuthSessionScope не найден в дереве виджетов');
    return scope!.notifier!;
  }
}
