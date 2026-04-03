import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/presentation/constants/home_assets.dart';

/// Полноэкранный фон первого сегмента (изображение + затемнение для читаемости).
class HomeHeroBackdrop extends StatelessWidget {
  const HomeHeroBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: 1.02,
            child: Image.asset(
              HomeAssets.heroBackground,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Подложка под [HomeHeroBackdrop] до загрузки картинки.
class HomeHeroFallbackBackground extends StatelessWidget {
  const HomeHeroFallbackBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppThemes.homeHeroFallbackBg, child: child);
  }
}
