import 'dart:ui' show Path;

import 'package:path_drawing/path_drawing.dart';

import 'package:project_temp/features/home/data/regional_victims_mock_data.dart';
import 'package:project_temp/features/home/domain/map_region_id.dart';

/// Слой path из SVG (viewBox 815×403).
class MapSvgPathLayer {
  MapSvgPathLayer({
    required this.path,
    required this.fillHex,
    required this.regionId,
    required this.thinWhiteStroke,
  });

  final Path path;
  final String fillHex;

  /// `null` для нейтральных зон (например #DADADA).
  final MapRegionId? regionId;

  /// Как у островка в исходном SVG: белая обводка 0.5.
  final bool thinWhiteStroke;
}

abstract final class MapSvgPathParser {
  static const viewBoxWidth = 815.0;
  static const viewBoxHeight = 403.0;

  /// Разбирает self-closing `<path .../>` из строки SVG.
  static List<MapSvgPathLayer> parse(String svg) {
    final pathTag = RegExp(r'<path\s([^/]+)/>');
    final out = <MapSvgPathLayer>[];
    for (final m in pathTag.allMatches(svg)) {
      final attrs = m.group(1)!;
      final dMatch = RegExp(r'\bd="([^"]*)"').firstMatch(attrs);
      final fillMatch = RegExp(r'fill="#([0-9A-Fa-f]{6})"').firstMatch(attrs);
      if (dMatch == null || fillMatch == null) continue;
      final d = dMatch.group(1)!;
      final fillHex = fillMatch.group(1)!.toUpperCase();
      final path = parseSvgPathData(d);
      final regionId = RegionalVictimsMockData.regionIdForSvgFill(fillHex);
      final thinWhiteStroke = attrs.contains('stroke="white"');
      out.add(
        MapSvgPathLayer(
          path: path,
          fillHex: fillHex,
          regionId: regionId,
          thinWhiteStroke: thinWhiteStroke,
        ),
      );
    }
    return out;
  }
}
