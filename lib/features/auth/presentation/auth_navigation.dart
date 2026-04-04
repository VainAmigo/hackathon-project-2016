import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/features/auth/cubit/auth_session_cubit.dart';
import 'package:project_temp/features/auth/presentation/pages/login_page.dart';
import 'package:project_temp/features/auth/presentation/widgets/login_required_dialog.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// Переход на экран, доступный только после входа. Иначе — диалог и экран входа.
Future<void> pushIfAuthenticated(
  BuildContext context, {
  required WidgetBuilder pageBuilder,
}) async {
  final authed = context.read<AuthSessionCubit>().state.isAuthenticated;

  Future<void> pushProtected() async {
    if (!context.mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: pageBuilder),
    );
  }

  if (authed) {
    await pushProtected();
    return;
  }

  final l10n = AppLocalizations.of(context);
  final goLogin = await showLoginRequiredDialog(
    context,
    message: l10n.authLoginRequiredBody,
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
  context.read<AuthSessionCubit>().setSession(user);
  await pushProtected();
}
