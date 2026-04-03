// ignore_for_file: implementation_imports

import 'package:desktop_drop/desktop_drop_web.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Регистрация web-реализаций плагинов, если автоматический registrant не подключился
/// (иначе [FilePicker.platform] падает с LateInitializationError).
void registerWebPluginImplementations() {
  var filePickerReady = false;
  try {
    FilePicker.platform;
    filePickerReady = true;
  } catch (_) {
    // LateInitializationError: web-реализация ещё не назначена на [FilePicker.platform].
  }
  if (filePickerReady) return;

  final registrar = webPluginRegistrar;
  FilePickerWeb.registerWith(registrar);
  DesktopDropWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
