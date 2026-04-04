import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/cubit/auth_session_cubit.dart';
import 'package:project_temp/features/auth/cubit/auth_session_state.dart';
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
  late final AuthSessionCubit _sessionCubit = AuthSessionCubit(sl());
  late AppLocaleController _locale;

  @override
  void initState() {
    super.initState();
    _locale = AppLocaleController(
      localePreferences: sl(),
      initialCode: widget.initialLanguage,
    );
    _sessionCubit.bootstrap();
  }

  @override
  void dispose() {
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
            locale: _locale.locale,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
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
