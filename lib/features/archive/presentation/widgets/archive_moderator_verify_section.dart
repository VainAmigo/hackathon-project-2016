import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/auth.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// PUT /api/v1/moderator/persons/{id}?approved= — только для роли MODERATOR.
class ArchiveModeratorVerifySection extends StatefulWidget {
  const ArchiveModeratorVerifySection({
    super.key,
    required this.personId,
    required this.l10n,
    required this.onSuccess,
  });

  final String personId;
  final AppLocalizations l10n;
  final VoidCallback onSuccess;

  @override
  State<ArchiveModeratorVerifySection> createState() =>
      _ArchiveModeratorVerifySectionState();
}

class _ArchiveModeratorVerifySectionState
    extends State<ArchiveModeratorVerifySection> {
  bool _busy = false;

  Future<void> _submit(bool approved) async {
    if (_busy) return;
    final id = widget.personId.trim();
    if (id.isEmpty) return;

    setState(() => _busy = true);
    final result = await sl<PersonsRepository>().moderatePerson(
      id,
      approved: approved,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    result.fold(
      (f) => AppSnackMessenger.showMessage(f.message, isError: true),
      (_) {
        AppSnackMessenger.showMessage(widget.l10n.archiveModeratorSuccess);
        widget.onSuccess();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionCubit, AuthSessionState>(
      buildWhen: (prev, curr) =>
          prev.isAuthenticated != curr.isAuthenticated ||
          prev.user?.role != curr.user?.role,
      builder: (context, session) {
        final mod = session.user?.isModerator == true;
        if (!mod) return const SizedBox.shrink();

        final l10n = widget.l10n;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.archiveModeratorVerifyTitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: AppThemes.textColorGrey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : () => _submit(true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppThemes.textColorPrimary,
                      side: BorderSide(
                        color: AppThemes.accentColor.withValues(alpha: 0.65),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _busy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.archiveModeratorApprove),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : () => _submit(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppThemes.textColorPrimary,
                      side: BorderSide(
                        color: AppThemes.textColorGrey.withValues(alpha: 0.45),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _busy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.archiveModeratorReject),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
