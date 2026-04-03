import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';

class _AuthEnter extends StatelessWidget {
  const _AuthEnter({
    required this.child,
    this.slideX = 0,
    this.slideY = 18,
    this.duration = const Duration(milliseconds: 480),
  });

  final Widget child;
  final double slideX;
  final double slideY;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(slideX * (1 - t), slideY * (1 - t)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Оболочка экранов входа/регистрации: [AppThemes], на широких окнах — бренд и карточка.
class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.cardTitle,
    required this.cardBody,
    this.footer,
    this.leading,
  });

  final String cardTitle;
  final Widget cardBody;
  final Widget? footer;
  final Widget? leading;

  static const double _cardMaxWidth = 440;

  Widget _brandPanelWide(BuildContext context, AppLocalizations l10n) {
    return ColoredBox(
      color: AppThemes.accentColor,
      child: SafeArea(
        child: _AuthEnter(
          slideX: -28,
          slideY: 0,
          duration: const Duration(milliseconds: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppThemes.surfaceColor,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.authPanelSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppThemes.surfaceColor.withValues(alpha: 0.88),
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = context.adaptive.canUseSideNavigation;

    final card = Material(
      color: AppThemes.surfaceColor,
      elevation: wide ? 4 : 1,
      shadowColor: AppThemes.textColorPrimary.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(wide ? 20 : 16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: wide ? 32 : 24,
          vertical: wide ? 28 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cardTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppThemes.textColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            cardBody,
            if (footer != null) ...[
              const SizedBox(height: 20),
              footer!,
            ],
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.backgroundColor,
        foregroundColor: AppThemes.textColorPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: leading,
      ),
      body: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: _brandPanelWide(context, l10n)),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _cardMaxWidth,
                        ),
                        child: _AuthEnter(
                          slideX: 24,
                          slideY: 0,
                          child: card,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    24 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        _AuthEnter(
                          slideY: 12,
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.appTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppThemes.accentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.authPanelSubtitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppThemes.textColorGrey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _cardMaxWidth,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: _AuthEnter(
                              slideY: 22,
                              duration: const Duration(milliseconds: 520),
                              child: card,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
