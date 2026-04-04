import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/auth.dart';
import 'package:project_temp/features/home/home.dart';

import '../l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key, this.initialLanguage});

  /// Восстановленный из [SharedPreferences] язык; если null — по умолчанию en.
  final AppLanguageCode? initialLanguage;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthSessionCubit _sessionCubit =
      AuthSessionCubit(sl(), sl());
  late AppLocaleController _locale;
  StreamSubscription<void>? _remoteInvalidSub;

  @override
  void initState() {
    super.initState();
    _locale = AppLocaleController(
      localePreferences: sl(),
      initialCode: widget.initialLanguage,
    );
    _remoteInvalidSub = AuthSessionRemoteInvalidated.stream.listen((_) {
      _sessionCubit.markSessionExpiredByRefresh();
    });
    _sessionCubit.bootstrap();
  }

  @override
  void dispose() {
    _remoteInvalidSub?.cancel();
    _sessionCubit.close();
    _locale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sessionCubit,
      child: ListenableBuilder(
        listenable: _locale,
        builder: (context, _) {
          return MaterialApp(
            scaffoldMessengerKey: AppSnackMessenger.scaffoldMessengerKey,
            locale: _locale.locale,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return BlocListener<AuthSessionCubit, AuthSessionState>(
                listenWhen: (prev, curr) =>
                    curr.notice != AuthSessionNotice.none &&
                    curr.notice != prev.notice,
                listener: (context, state) {
                  final l10n = AppLocalizations.of(context);
                  late final String text;
                  var isError = false;
                  switch (state.notice) {
                    case AuthSessionNotice.loginSuccess:
                      text = l10n.authSnackLoginSuccess;
                    case AuthSessionNotice.logoutSuccess:
                      text = l10n.authSnackLogoutSuccess;
                    case AuthSessionNotice.refreshFailedOnStartup:
                      text = l10n.authSnackRefreshFailedOnStartup;
                      isError = true;
                    case AuthSessionNotice.sessionExpiredRefresh:
                      text = l10n.authSnackSessionExpiredRefresh;
                      isError = true;
                    case AuthSessionNotice.none:
                      return;
                  }
                  AppSnackMessenger.showMessage(text, isError: isError);
                  context.read<AuthSessionCubit>().clearNotice();
                },
                child: child ?? const SizedBox.shrink(),
              );
            },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
            home: BlocBuilder<AuthSessionCubit, AuthSessionState>(
              builder: (context, session) {
                if (!session.bootstrapped) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return AppLocaleScope(
                  notifier: _locale,
                  child: const HomePage(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
