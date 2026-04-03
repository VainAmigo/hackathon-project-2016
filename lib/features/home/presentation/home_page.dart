import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/presentation/auth_navigation.dart';
import 'package:project_temp/features/auth/presentation/auth_session_scope.dart';
import 'package:project_temp/features/auth/presentation/login_page.dart';
import 'package:project_temp/features/home/presentation/protected_example_page.dart';
import 'package:project_temp/source/source.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loggingOut = false;

  AuthRepository get _auth => sl();

  Future<void> _onLogout() async {
    setState(() => _loggingOut = true);
    final result = await _auth.logout();
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
    final session = AuthSessionScope.of(context);
    final u = session.user;
    final authed = session.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          if (!authed)
            IconButton(
              tooltip: 'Войти',
              onPressed: _openLogin,
              icon: const Icon(Icons.login),
            )
          else if (_loggingOut)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              tooltip: 'Выйти',
              onPressed: _onLogout,
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: ListView(
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
                    ? (u != null
                        ? u.displayName
                        : 'Сессия активна, данные профиля — после входа в этом запуске.')
                    : 'Часть разделов доступна только после входа.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () {
              pushIfAuthenticated(
                context,
                pageBuilder: (_) => const ProtectedExamplePage(),
              );
            },
            icon: const Icon(Icons.lock_open_outlined),
            label: const Text('Пример: закрытый раздел'),
          ),
          const SizedBox(height: 24),
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
          else if (u == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Сессия активна. Данные профиля доступны после входа в этом запуске приложения.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          else
            Column(
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
            ),
        ],
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
