import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_temp/core/adaptive/adaptive_breakpoints.dart';
import 'package:project_temp/core/adaptive/adaptive_data.dart';

/// Ветвление UI: отдельные деревья для веба и нативного клиента.
class AdaptiveHostBuilder extends StatelessWidget {
  const AdaptiveHostBuilder({
    super.key,
    required this.web,
    required this.native,
  });

  final WidgetBuilder web;
  final WidgetBuilder native;

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? web(context) : native(context);
  }
}

/// Полный контроль: [AdaptiveData] + произвольная логика.
class AdaptiveDataBuilder extends StatelessWidget {
  const AdaptiveDataBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, AdaptiveData data) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.adaptive);
  }
}

/// Отдельные виджеты по классу ширины окна (без привязки к веб/натив).
///
/// Не переданные уровни подменяются ближайшим более широким, затем более узким
/// (например, только [compact] и [expanded]: medium возьмёт [expanded]).
class AdaptiveWindowBuilder extends StatelessWidget {
  const AdaptiveWindowBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;
  final WidgetBuilder? large;

  @override
  Widget build(BuildContext context) {
    final data = context.adaptive;
    switch (data.windowClass) {
      case AdaptiveWindowClass.compact:
        return compact(context);
      case AdaptiveWindowClass.medium:
        return (medium ?? expanded ?? large ?? compact)(context);
      case AdaptiveWindowClass.expanded:
        return (expanded ?? large ?? medium ?? compact)(context);
      case AdaptiveWindowClass.large:
        return (large ?? expanded ?? medium ?? compact)(context);
    }
  }
}
