import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/auth.dart';
import 'package:project_temp/features/home/home.dart';
import 'package:project_temp/source/source.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  int _tabIndex = 0;
  bool _loggingOut = false;

  AuthRepository get _authRepo => sl();

  bool _denseNav(AdaptiveData a) => a.isCompactLayout || a.width < 800;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onLogout() async {
    setState(() => _loggingOut = true);
    final result = await _authRepo.logout();
    if (!mounted) return;
    setState(() => _loggingOut = false);
    result.fold((f) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message)));
    }, (_) => AuthSessionScope.read(context).clearSession());
  }

  Future<void> _openLogin() async {
    final user = await Navigator.of(context).push<User>(
      MaterialPageRoute<User>(
        builder: (ctx) =>
            LoginPage(onLoggedIn: (u) => Navigator.of(ctx).pop(u)),
      ),
    );
    if (user != null && mounted) {
      AuthSessionScope.read(context).setSession(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adaptive = context.adaptive;
    final dense = _denseNav(adaptive);
    final session = AuthSessionScope.of(context);
    final authed = session.isAuthenticated;

    final mainContent = _tabBody(tabIndex: _tabIndex);

    final Widget paddedBody;
    if (adaptive.isWeb && _tabIndex != 0) {
      paddedBody = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: adaptive.canUseSideNavigation ? 960 : 560,
          ),
          child: mainContent,
        ),
      );
    } else {
      paddedBody = mainContent;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: dense ? null : AppThemes.backgroundColor,
      drawer: dense
          ? VoiceArchiveDrawer(
              selectedTab: _tabIndex,
              onTabSelected: (i) => setState(() => _tabIndex = i),
              searchController: _searchController,
              isAuthenticated: authed,
              loggingOut: _loggingOut,
              onLogin: _openLogin,
              onLogout: _onLogout,
            )
          : null,
      appBar: VoiceArchiveAppBar(
        scaffoldKey: _scaffoldKey,
        selectedTab: _tabIndex,
        onTabSelected: (i) => setState(() => _tabIndex = i),
        searchController: _searchController,
        isAuthenticated: authed,
        loggingOut: _loggingOut,
        onLogin: _openLogin,
        onLogout: _onLogout,
      ),
      body: paddedBody,
    );
  }

  Widget _tabBody({required int tabIndex}) {
    switch (tabIndex) {
      case 1:
        return const HomeTabPlaceholderPage(
          title: 'AI Assistant',
          subtitle: 'Здесь будет помощник.',
        );
      case 2:
        return const HomeTabPlaceholderPage(
          title: 'Add Entry',
          subtitle: 'Здесь будет форма добавления записи.',
        );
      case 0:
      default:
        return HomeLandingBody(
          onOpenAiAssistant: () => setState(() => _tabIndex = 1),
        );
    }
  }
}
