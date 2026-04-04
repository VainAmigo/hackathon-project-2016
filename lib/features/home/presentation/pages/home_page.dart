import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/auth.dart';
import 'package:project_temp/features/add_entry/add_entry.dart';
import 'package:project_temp/features/chat/chat.dart';
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
    }, (_) => context.read<AuthSessionCubit>().clearSession());
  }

  Future<void> _openLogin() async {
    final user = await Navigator.of(context).push<User>(
      MaterialPageRoute<User>(
        builder: (ctx) =>
            LoginPage(onLoggedIn: (u) => Navigator.of(ctx).pop(u)),
      ),
    );
    if (user != null && mounted) {
      context.read<AuthSessionCubit>().setSession(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adaptive = context.adaptive;
    final dense = _denseNav(adaptive);
    final authed = context.watch<AuthSessionCubit>().state.isAuthenticated;

    final mainContent = AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_tabIndex),
        child: _tabBody(context, tabIndex: _tabIndex),
      ),
    );

    final Widget paddedBody;
    // Главная и чат — на всю ширину; остальные вкладки на вебе — в узкой колонке.
    if (adaptive.isWeb && _tabIndex != 0 && _tabIndex != 1) {
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
      backgroundColor: AppThemes.backgroundColor,
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

  Widget _tabBody(BuildContext context, {required int tabIndex}) {
    switch (tabIndex) {
      case 1:
        return const ChatAssistantPage();
      case 2:
        return const AddEntryPage();
      case 0:
      default:
        return HomeLandingBody(
          onOpenAiAssistant: () => setState(() => _tabIndex = 1),
        );
    }
  }
}
