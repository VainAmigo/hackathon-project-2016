import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/application/auth_session_controller.dart';
import 'package:project_temp/features/auth/presentation/auth_session_scope.dart';
import 'package:project_temp/features/home/presentation/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthSessionController _auth = AuthSessionController(sl());
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _auth.bootstrap().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: _ready
          ? AuthSessionScope(
              notifier: _auth,
              child: const HomePage(),
            )
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
