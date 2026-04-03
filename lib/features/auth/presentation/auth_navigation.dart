import 'package:flutter/material.dart';
import 'package:project_temp/features/auth/presentation/auth_session_scope.dart';
import 'package:project_temp/features/auth/presentation/login_page.dart';
import 'package:project_temp/source/source.dart';

/// Переход на экран, доступный только после входа. Иначе — диалог и экран входа.
Future<void> pushIfAuthenticated(
  BuildContext context, {
  required WidgetBuilder pageBuilder,
}) async {
  final session = AuthSessionScope.read(context);

  Future<void> pushProtected() async {
    if (!context.mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: pageBuilder),
    );
  }

  if (session.isAuthenticated) {
    await pushProtected();
    return;
  }

  final goLogin = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Нужен вход'),
      content: const Text(
        'Этот раздел доступен только авторизованным пользователям. Войдите в аккаунт.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Войти'),
        ),
      ],
    ),
  );

  if (goLogin != true || !context.mounted) return;

  final user = await Navigator.of(context).push<User>(
    MaterialPageRoute<User>(
      fullscreenDialog: true,
      builder: (ctx) => LoginPage(
        onLoggedIn: (u) => Navigator.of(ctx).pop(u),
      ),
    ),
  );

  if (user == null || !context.mounted) return;
  AuthSessionScope.read(context).setSession(user);
  await pushProtected();
}
