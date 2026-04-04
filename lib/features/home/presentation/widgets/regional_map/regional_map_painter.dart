import 'package:flutter/material.dart';

import 'package:project_temp/features/home/data/map_svg_path_parser.dart';
import 'package:project_temp/features/home/domain/map_region_id.dart';

/// Отрисовка регионов карты в координатах viewBox 815×403.
class RegionalMapPainter extends CustomPainter {
  RegionalMapPainter({
    required this.layers,
    this.highlighted,
  });

  final List<MapSvgPathLayer> layers;
  final MapRegionId? highlighted;

  static Color _fillColor(MapSvgPathLayer layer, MapRegionId? highlighted) {
    final base = Color(0xFF000000 | int.parse(layer.fillHex, radix: 16));
    if (layer.regionId == null) return base;
    if (highlighted != null && layer.regionId == highlighted) {
      return Color.lerp(base, Colors.black, 0.12)!;
    }
    return base;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / MapSvgPathParser.viewBoxWidth;
    final sy = size.height / MapSvgPathParser.viewBoxHeight;
    canvas.save();
    canvas.scale(sx, sy);
    for (final layer in layers) {
      final fill = Paint()..style = PaintingStyle.fill;
      fill.color = _fillColor(layer, highlighted);
      canvas.drawPath(layer.path, fill);
      if (layer.thinWhiteStroke) {
        final stroke = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = Colors.white;
        canvas.drawPath(layer.path, stroke);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RegionalMapPainter oldDelegate) {
    return oldDelegate.highlighted != highlighted ||
        !identical(oldDelegate.layers, layers);
  }
}
