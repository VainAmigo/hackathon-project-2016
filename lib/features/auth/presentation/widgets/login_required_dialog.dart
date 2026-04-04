import 'package:flutter/material.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';

import '../../../../l10n/app_localizations.dart';

/// Модалка в стиле карточки [AuthPageScaffold]: кремовый фон, типографика приложения.
Future<bool?> showLoginRequiredDialog(
  BuildContext context, {
  required String message,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierColor: AppThemes.textColorPrimary.withValues(alpha: 0.42),
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Material(
            color: AppThemes.surfaceColor,
            elevation: 4,
            shadowColor: AppThemes.textColorPrimary.withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 28, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.authLoginRequiredEyebrow,
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.15,
                      fontWeight: FontWeight.w600,
                      color: AppThemes.textColorGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authLoginRequiredTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppThemes.textColorPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppThemes.textColorSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 26),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: AppThemes.textColorSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      alignment: Alignment.center,
                    ),
                    child: Text(
                      l10n.authDialogCancel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  PrimaryButton(
                    text: l10n.actionLogin,
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
