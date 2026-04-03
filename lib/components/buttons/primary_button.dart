import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    this.onPressed,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
  });

  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        foregroundColor: foregroundColor ?? AppThemes.surfaceColor,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        backgroundColor: backgroundColor ?? AppThemes.textColorPrimary,
        disabledBackgroundColor: AppThemes.textColorPrimary.withValues(
          alpha: 0.3,
        ),
        disabledForegroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: child ?? Text(text),
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
