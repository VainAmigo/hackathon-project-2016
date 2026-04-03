import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.user,
    required this.onLoggedOut,
  });

  /// После перезапуска приложения может быть `null` (токен есть, кэша профиля нет).
  final User? user;

  final VoidCallback onLoggedOut;

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
      (_) => widget.onLoggedOut(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          if (_loggingOut)
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
      body: u == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Сессия активна. Данные профиля доступны после входа в этом запуске приложения.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
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
