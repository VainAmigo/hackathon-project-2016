import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/home/data/map_svg_path_parser.dart';
import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/features/home/presentation/constants/home_assets.dart';
import 'package:project_temp/features/home/presentation/widgets/regional_map/regional_map_painter.dart';

/// Интерактивная карта: тап по региону с [MapRegionId] вызывает [onRegionTap].
class HomeInteractiveRegionalMap extends StatefulWidget {
  const HomeInteractiveRegionalMap({
    super.key,
    required this.onRegionTap,
    this.highlighted,
  });

  final void Function(MapRegionId id) onRegionTap;
  final MapRegionId? highlighted;

  @override
  State<HomeInteractiveRegionalMap> createState() =>
      _HomeInteractiveRegionalMapState();
}

class _HomeInteractiveRegionalMapState extends State<HomeInteractiveRegionalMap> {
  late final Future<List<MapSvgPathLayer>> _layersFuture;

  @override
  void initState() {
    super.initState();
    _layersFuture = _loadLayers();
  }

  Future<List<MapSvgPathLayer>> _loadLayers() async {
    final raw = await rootBundle.loadString(HomeAssets.regionalMapSvg);
    return MapSvgPathParser.parse(raw);
  }

  MapRegionId? _hitTest(Offset local, Size size, List<MapSvgPathLayer> layers) {
    final sx = size.width / MapSvgPathParser.viewBoxWidth;
    final sy = size.height / MapSvgPathParser.viewBoxHeight;
    final x = local.dx / sx;
    final y = local.dy / sy;
    final p = Offset(x, y);
    for (final layer in layers.reversed) {
      if (layer.regionId != null && layer.path.contains(p)) {
        return layer.regionId;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapSvgPathLayer>>(
      future: _layersFuture,
      builder: (context, snap) {
        if (snap.hasError) {
          return _MapPlaceholder(
            child: Text(
              'Не удалось загрузить карту',
              style: TextStyle(color: AppThemes.textColorSecondary),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (!snap.hasData) {
          return const _MapPlaceholder(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final layers = snap.data!;
        return AspectRatio(
          aspectRatio:
              MapSvgPathParser.viewBoxWidth / MapSvgPathParser.viewBoxHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTapDown: (details) {
                    final hit = _hitTest(details.localPosition, size, layers);
                    if (hit != null) widget.onRegionTap(hit);
                  },
                  splashColor: AppThemes.accentColor.withValues(alpha: 0.08),
                  highlightColor: AppThemes.accentColor.withValues(alpha: 0.04),
                  child: CustomPaint(
                    painter: RegionalMapPainter(
                      layers: layers,
                      highlighted: widget.highlighted,
                    ),
                    size: size,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          MapSvgPathParser.viewBoxWidth / MapSvgPathParser.viewBoxHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppThemes.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppThemes.textColorGrey.withValues(alpha: 0.2),
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
