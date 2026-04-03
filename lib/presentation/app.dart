import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/application/auth_session_controller.dart';
import 'package:project_temp/features/auth/presentation/auth_session_scope.dart';
import 'package:project_temp/features/home/home.dart';

class App extends StatefulWidget {
  const App({super.key, this.initialLanguage});

  /// Восстановленный из [SharedPreferences] язык; если null — по умолчанию en.
  final AppLanguageCode? initialLanguage;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthSessionController _auth = AuthSessionController(sl());
  late AppLocaleController _locale;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _locale = AppLocaleController(
      localePreferences: sl(),
      initialCode: widget.initialLanguage,
    );
    _auth.bootstrap().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _locale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_auth, _locale]),
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
          home: _ready
              ? AuthSessionScope(
                  notifier: _auth,
                  child: AppLocaleScope(
                    notifier: _locale,
                    child: const HomePage(),
                  ),
                )
              : const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
        );
      },
    );
  }
}
