import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';

import 'bootstrap/web_plugins_register_stub.dart'
    if (dart.library.html) 'bootstrap/web_plugins_register_web.dart';
import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerWebPluginImplementations();
  await initDependencies();
  final initialLanguage = parseSavedLanguageCode(
    sl<LocalePreferences>().readLanguageCode(),
  );
  runApp(App(initialLanguage: initialLanguage));
}
