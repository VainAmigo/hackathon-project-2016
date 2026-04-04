import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';

/// Внешний вид кнопки: заливка или только обводка (например, гость / сессия в аппбаре).
enum PrimaryButtonVariant { filled, outlined }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    this.onPressed,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.variant = PrimaryButtonVariant.filled,
    this.iconOnly = false,
    this.icon,
  }) : assert(!iconOnly || icon != null, 'icon is required when iconOnly is true');

  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final PrimaryButtonVariant variant;
  /// Квадратная кнопка фиксированного размера; подпись [text] уходит в [Semantics] и [Tooltip].
  final bool iconOnly;
  final IconData? icon;

  static const double _height = 50;
  static const double _iconSide = 50;

  @override
  Widget build(BuildContext context) {
    final effectiveFg = foregroundColor ??
        (variant == PrimaryButtonVariant.outlined
            ? AppThemes.textColorPrimary
            : AppThemes.surfaceColor);

    final buttonChild = child ??
        (iconOnly && icon != null
            ? Icon(icon, size: 22, color: effectiveFg)
            : Text(text, textAlign: TextAlign.center));

    late final Widget materialButton;
    switch (variant) {
      case PrimaryButtonVariant.outlined:
        materialButton = OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: iconOnly ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            foregroundColor: foregroundColor ?? AppThemes.textColorPrimary,
            side: BorderSide(
              color: foregroundColor ?? AppThemes.textColorPrimary,
              width: 1.5,
            ),
            disabledForegroundColor: AppThemes.textColorPrimary.withValues(alpha: 0.35),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onPressed: onPressed,
          child: buttonChild,
        );
      case PrimaryButtonVariant.filled:
        materialButton = ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: iconOnly ? EdgeInsets.zero : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            foregroundColor: effectiveFg,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            backgroundColor: backgroundColor ?? AppThemes.textColorPrimary,
            disabledBackgroundColor: AppThemes.textColorPrimary.withValues(
              alpha: 0.3,
            ),
            disabledForegroundColor: Colors.white,
          ),
          onPressed: onPressed,
          child: buttonChild,
        );
    }

    final core = SizedBox(
      width: iconOnly ? _iconSide : double.infinity,
      height: _height,
      child: materialButton,
    );

    if (!iconOnly) {
      return Semantics(button: true, label: text, child: core);
    }

    return Tooltip(
      message: text,
      child: Semantics(button: true, label: text, child: core),
    );
  }
}

class CenteredProgressingButton extends StatelessWidget {
  const CenteredProgressingButton(this.color, {super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? AppThemes.surfaceColor),
    );
  }
}
