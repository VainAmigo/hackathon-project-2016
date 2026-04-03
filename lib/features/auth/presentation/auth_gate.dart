import 'package:flutter/material.dart';
import 'package:project_temp/features/auth/presentation/login_page.dart';
import 'package:project_temp/features/home/presentation/home_page.dart';
import 'package:project_temp/source/source.dart';
import 'package:project_temp/core/core.dart';

/// Есть токен → главная; нет → вход. [User] только в памяти после логина (кэша профиля нет).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _hasToken = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final token = await sl<PreferencesService>().getAccessToken();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _hasToken = token != null && token.isNotEmpty;
    });
  }

  void _onLoggedIn(User user) {
    setState(() {
      _hasToken = true;
      _user = user;
    });
  }

  void _onLoggedOut() {
    setState(() {
      _hasToken = false;
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_hasToken) {
      return LoginPage(onLoggedIn: _onLoggedIn);
    }
    return HomePage(user: _user, onLoggedOut: _onLoggedOut);
  }
}
