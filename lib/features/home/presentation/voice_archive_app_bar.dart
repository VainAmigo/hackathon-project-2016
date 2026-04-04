import 'package:flutter/material.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';

/// Фон шапки по макету.
const Color kVoiceArchiveCream = Color(0xFFFDFCE6);

/// Индексы вкладок: 0 — Archive, 1 — AI Assistant, 2 — Add Entry.
class VoiceArchiveAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const VoiceArchiveAppBar({
    super.key,
    required this.scaffoldKey,
    required this.selectedTab,
    required this.onTabSelected,
    required this.searchController,
    required this.isAuthenticated,
    this.loggingOut = false,
    this.onLogin,
    this.onLogout,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final TextEditingController searchController;
  final bool isAuthenticated;
  final bool loggingOut;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;

  bool _dense(AdaptiveData a) => a.isCompactLayout || a.width < 800;

  @override
  Size get preferredSize {
    return const Size.fromHeight(72);
  }

  @override
  Widget build(BuildContext context) {
    final adaptive = context.adaptive;
    final dense = _dense(adaptive);
    final locale = AppLocaleScope.of(context);
    final l10n = context.l10n;
    final tabLabels = <String>[
      l10n.navArchive,
      l10n.navAiAssistant,
      l10n.navAddEntry,
    ];

    return Material(
      color: AppThemes.backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: dense
              ? _MobileTopBar(
                  scaffoldKey: scaffoldKey,
                  selectedTab: selectedTab,
                  onTabSelected: onTabSelected,
                  searchController: searchController,
                  isAuthenticated: isAuthenticated,
                  loggingOut: loggingOut,
                  onLogin: onLogin,
                  onLogout: onLogout,
                  tabLabels: tabLabels,
                  locale: locale,
                )
              : _DesktopTopBar(
                  selectedTab: selectedTab,
                  onTabSelected: onTabSelected,
                  searchController: searchController,
                  isAuthenticated: isAuthenticated,
                  loggingOut: loggingOut,
                  onLogin: onLogin,
                  onLogout: onLogout,
                  tabLabels: tabLabels,
                  locale: locale,
                ),
        ),
      ),
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({
    required this.selectedTab,
    required this.onTabSelected,
    required this.searchController,
    required this.isAuthenticated,
    required this.loggingOut,
    required this.onLogin,
    required this.onLogout,
    required this.tabLabels,
    required this.locale,
  });

  /// Левая зона (бренд + вкладки) забирает большую долю свободной ширины;
  /// поиск сжимается первым и остаётся узким дольше, чем скрывается левый контент.
  static const int _leftFlex = 14;
  static const int _searchFlex = 2;

  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final TextEditingController searchController;
  final bool isAuthenticated;
  final bool loggingOut;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;
  final List<String> tabLabels;
  final AppLocaleController locale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: _leftFlex,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BrandTitle(compact: false),
                    const SizedBox(width: 16),
                    _NavTabs(
                      labels: tabLabels,
                      selected: selectedTab,
                      onSelected: onTabSelected,
                      compact: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: _searchFlex,
            child: Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: CustomTextFormField(
                  controller: searchController,
                  hintText: context.l10n.searchHint,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          _LangToggle(controller: locale),
          const SizedBox(width: 12),
          _AuthChip(
            isAuthenticated: isAuthenticated,
            loggingOut: loggingOut,
            onLogin: onLogin,
            onLogout: onLogout,
            compact: false,
          ),
        ],
      ),
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({
    required this.scaffoldKey,
    required this.selectedTab,
    required this.onTabSelected,
    required this.searchController,
    required this.isAuthenticated,
    required this.loggingOut,
    required this.onLogin,
    required this.onLogout,
    required this.tabLabels,
    required this.locale,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final TextEditingController searchController;
  final bool isAuthenticated;
  final bool loggingOut;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;
  final List<String> tabLabels;
  final AppLocaleController locale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            tooltip: context.l10n.tooltipMenu,
          ),
          Expanded(child: Center(child: _BrandTitle(compact: true))),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            tooltip: context.l10n.tooltipSearch,
            onPressed: () => _openSearchSheet(context),
          ),
          _LangToggle(controller: locale, dense: true),
          const SizedBox(width: 4),
          _AuthChip(
            isAuthenticated: isAuthenticated,
            loggingOut: loggingOut,
            onLogin: onLogin,
            onLogout: onLogout,
            compact: true,
          ),
        ],
      ),
    );
  }

  void _openSearchSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.paddingOf(ctx).bottom + 20,
          ),
          child: CustomTextFormField(
            controller: searchController,
            autofocus: true,
            hintText: ctx.l10n.searchHint,
          ),
        );
      },
    );
  }
}

/// Содержимое [Drawer] для узкой вёрстки.
class VoiceArchiveDrawer extends StatelessWidget {
  const VoiceArchiveDrawer({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.searchController,
    required this.isAuthenticated,
    this.loggingOut = false,
    this.onLogin,
    this.onLogout,
  });

  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final TextEditingController searchController;
  final bool isAuthenticated;
  final bool loggingOut;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final l10n = context.l10n;
    final tabLabels = <String>[
      l10n.navArchive,
      l10n.navAiAssistant,
      l10n.navAddEntry,
    ];

    return Drawer(
      backgroundColor: kVoiceArchiveCream,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _BrandTitle(compact: false),
            const SizedBox(height: 24),
            for (var i = 0; i < tabLabels.length; i++)
              ListTile(
                title: Text(
                  tabLabels[i],
                  style: TextStyle(
                    fontWeight: selectedTab == i
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: selectedTab == i ? Colors.black : Colors.black54,
                  ),
                ),
                selected: selectedTab == i,
                onTap: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTabSelected(i);
                  });
                },
              ),
            const Divider(height: 32),
            CustomTextFormField(
              controller: searchController,
              hintText: l10n.searchHint,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(l10n.drawerLanguage),
              trailing: Text(
                locale.code.uiLabel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () {
                locale.cycle();
              },
            ),
            const SizedBox(height: 12),
            _AuthChip(
              isAuthenticated: isAuthenticated,
              loggingOut: loggingOut,
              onLogin: onLogin,
              onLogout: onLogout,
              compact: false,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final title = 'Voice from the Archive';
    final style = TextStyle(
      fontFamily: 'serif',
      fontWeight: FontWeight.w700,
      fontSize: compact ? 15 : 18,
      height: 1.15,
      color: Colors.black,
    );
    if (compact) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: style,
      );
    }
    return Text(title, style: style);
  }
}

class _NavTabs extends StatelessWidget {
  const _NavTabs({
    required this.labels,
    required this.selected,
    required this.onSelected,
    required this.compact,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) SizedBox(width: compact ? 12 : 20),
          _NavTab(
            label: labels[i],
            selected: selected == i,
            onTap: () => onSelected(i),
            compact: compact,
          ),
        ],
      ],
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.compact,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 10,
          vertical: compact ? 6 : 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                letterSpacing: 0.6,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.black : Colors.black45,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              height: 3,
              width: compact ? 48 : 64,
              decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Скругление кнопки языка: у каждого кода своя «форма», переход анимируется [AnimatedContainer].
BorderRadius _langToggleBorderRadius(AppLanguageCode code) {
  return switch (code) {
    AppLanguageCode.en => BorderRadius.circular(2),
    AppLanguageCode.ky => BorderRadius.circular(25),
    AppLanguageCode.ru => const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(16),
        bottomLeft: Radius.circular(4),
      ),
    AppLanguageCode.tr => BorderRadius.circular(14),
  };
}

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.controller, this.dense = false});

  final AppLocaleController controller;
  final bool dense;

  static const _animDuration = Duration(milliseconds: 360);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final code = controller.code;
        final side = 50.0;
        final radius = _langToggleBorderRadius(code);
        final fontSize = dense ? 11.0 : 12.0;
        return Tooltip(
          message: context.l10n.drawerLanguage,
          child: Semantics(
            button: true,
            label: context.l10n.drawerLanguage,
            child: AnimatedContainer(
              duration: _animDuration,
              curve: Curves.easeInOutCubic,
              width: side,
              height: side,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: radius,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.cycle,
                  borderRadius: radius,
                  splashColor: AppThemes.backgroundColor.withValues(alpha: 0.22),
                  highlightColor: AppThemes.backgroundColor.withValues(alpha: 0.08),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        );
                        return FadeTransition(
                          opacity: curved,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.82, end: 1).animate(curved),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        code.uiLabel,
                        key: ValueKey<String>(code.name),
                        style: TextStyle(
                          color: AppThemes.backgroundColor,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthChip extends StatelessWidget {
  const _AuthChip({
    required this.isAuthenticated,
    required this.loggingOut,
    required this.onLogin,
    required this.onLogout,
    required this.compact,
    this.fullWidth = false,
  });

  final bool isAuthenticated;
  final bool loggingOut;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;
  final bool compact;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    if (loggingOut) {
      return SizedBox(
        width: 50,
        height: 50,
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final label = isAuthenticated
        ? context.l10n.actionLogout
        : context.l10n.actionLogin;
    final onPressed = isAuthenticated ? onLogout : onLogin;

    if (compact) {
      return PrimaryButton(
        text: label,
        onPressed: onPressed,
        iconOnly: true,
        icon: isAuthenticated ? Icons.logout : Icons.login,
        variant: isAuthenticated
            ? PrimaryButtonVariant.filled
            : PrimaryButtonVariant.outlined,
      );
    }

    final child = SizedBox(
      width: 120,
      child: PrimaryButton(text: label, onPressed: onPressed),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: child);
    }
    return child;
  }
}
