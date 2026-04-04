import 'package:flutter/material.dart';

/// Корневой [ScaffoldMessenger] для snackbar без локального [BuildContext].
abstract final class AppSnackMessenger {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showMessage(
    String text, {
    bool isError = false,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFF8B1A1A) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }
}
