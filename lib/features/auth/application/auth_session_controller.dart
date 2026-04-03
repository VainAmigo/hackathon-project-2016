import 'package:flutter/foundation.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

/// Состояние входа в приложении: флаг по токену из хранилища и [User] в памяти после логина.
class AuthSessionController extends ChangeNotifier {
  AuthSessionController(this._prefs);

  final PreferencesService _prefs;

  bool _bootstrapped = false;
  bool get isBootstrapped => _bootstrapped;

  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;

  User? _user;
  User? get user => _user;

  Future<void> bootstrap() async {
    final token = await _prefs.getAccessToken();
    _authenticated = token != null && token.isNotEmpty;
    _bootstrapped = true;
    notifyListeners();
  }

  void setSession(User user) {
    _authenticated = true;
    _user = user;
    notifyListeners();
  }

  void clearSession() {
    _authenticated = false;
    _user = null;
    notifyListeners();
  }
}
