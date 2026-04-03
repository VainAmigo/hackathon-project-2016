import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/auth.dart';
import 'package:project_temp/features/home/presentation/voice_archive_app_bar.dart';
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
    result.fold(
      (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
      (_) => AuthSessionScope.read(context).clearSession(),
    );
  }

  Future<void> _openLogin() async {
    final user = await Navigator.of(context).push<User>(
      MaterialPageRoute<User>(
        builder: (ctx) => LoginPage(
          onLoggedIn: (u) => Navigator.of(ctx).pop(u),
        ),
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
    final u = session.user;
    final authed = session.isAuthenticated;

    final mainContent = _buildTabBody(
      context: context,
      tabIndex: _tabIndex,
      authed: authed,
      user: u,
    );

    final paddedBody = adaptive.isWeb
        ? Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: adaptive.canUseSideNavigation ? 960 : 560,
              ),
              child: mainContent,
            ),
          )
        : mainContent;

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

  Widget _buildTabBody({
    required BuildContext context,
    required int tabIndex,
    required bool authed,
    required User? user,
  }) {
    switch (tabIndex) {
      case 1:
        return _PlaceholderTab(
          title: 'AI Assistant',
          subtitle: 'Здесь будет помощник.',
        );
      case 2:
        return _PlaceholderTab(
          title: 'Add Entry',
          subtitle: 'Здесь будет форма добавления записи.',
        );
      case 0:
      default:
        return _ArchiveHomeBody(
          authed: authed,
          user: user,
        );
    }
  }
}

class _ArchiveHomeBody extends StatelessWidget {
  const _ArchiveHomeBody({
    required this.authed,
    required this.user,
  });

  final bool authed;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: ListTile(
            leading: Icon(
              authed ? Icons.verified_user_outlined : Icons.person_off_outlined,
              color: authed
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            title: Text(
              authed ? 'Вы вошли в аккаунт' : 'Вы не авторизованы',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              authed
                  ? (user != null
                      ? user!.displayName
                      : 'Сессия активна, данные профиля — после входа в этом запуске.')
                  : 'Часть разделов доступна только после входа.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!authed)
          Center(
            child: Text(
              'Откройте пример выше — появится запрос войти.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          )
        else if (user == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Сессия активна. Данные профиля доступны после входа в этом запуске приложения.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        else
          Builder(
            builder: (context) {
              final u = user!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 28,
                      child: Text(_avatarLetter(u)),
                    ),
                    title: Text(
                      u.displayName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(u.phoneNumber),
                  ),
                  const Divider(height: 32),
                  _InfoRow(label: 'Телефон', value: u.phoneNumber),
                  if (u.email != null && u.email!.isNotEmpty)
                    _InfoRow(label: 'Email', value: u.email!),
                  if (u.firstName.isNotEmpty || u.lastName.isNotEmpty) ...[
                    _InfoRow(label: 'Имя', value: u.firstName),
                    _InfoRow(label: 'Фамилия', value: u.lastName),
                    if (u.middleName != null && u.middleName!.isNotEmpty)
                      _InfoRow(label: 'Отчество', value: u.middleName!),
                  ],
                  if (u.verificationStatus != null &&
                      u.verificationStatus!.isNotEmpty)
                    _InfoRow(
                      label: 'Верификация',
                      value: u.verificationStatus!,
                    ),
                  if (u.personId != null)
                    _InfoRow(label: 'Person ID', value: '${u.personId}'),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

String _avatarLetter(User u) {
  final s = u.displayName.trim().isNotEmpty
      ? u.displayName.trim()
      : u.phoneNumber.trim();
  if (s.isEmpty) return '?';
  return String.fromCharCode(s.runes.first).toUpperCase();
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
