import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/features/home/domain/regional_map_summary.dart'
    show RegionalMapSummary, RegionVictimCount;
import 'package:project_temp/features/home/domain/victim_record.dart';

/// Статические мок-данные: названия регионов, цвета SVG и списки жертв.
abstract final class RegionalVictimsMockData {
  static const int colorMarmara = 0xFF8481CA;
  static const int colorAegean = 0xFFCA8181;
  static const int colorMediterranean = 0xFF81CABE;
  static const int colorCentral = 0xFFA6CA81;
  static const int colorBlackSea = 0xFF81ACCA;
  static const int colorEastern = 0xFF81CA84;
  static const int colorSoutheast = 0xFFCA81BB;

  static String regionName(MapRegionId id) {
    switch (id) {
      case MapRegionId.marmara:
        return 'Мраморноморский регион';
      case MapRegionId.aegean:
        return 'Эгейский регион';
      case MapRegionId.mediterranean:
        return 'Средиземноморский регион';
      case MapRegionId.centralAnatolia:
        return 'Центральная Анатолия';
      case MapRegionId.blackSea:
        return 'Черноморский регион';
      case MapRegionId.easternAnatolia:
        return 'Восточная Анатолия';
      case MapRegionId.southeastAnatolia:
        return 'Юго-восточная Анатолия';
    }
  }

  static int regionColor(MapRegionId id) {
    switch (id) {
      case MapRegionId.marmara:
        return colorMarmara;
      case MapRegionId.aegean:
        return colorAegean;
      case MapRegionId.mediterranean:
        return colorMediterranean;
      case MapRegionId.centralAnatolia:
        return colorCentral;
      case MapRegionId.blackSea:
        return colorBlackSea;
      case MapRegionId.easternAnatolia:
        return colorEastern;
      case MapRegionId.southeastAnatolia:
        return colorSoutheast;
    }
  }

  /// Hex заливки в SVG → регион (см. [assets/images/map.svg]).
  static MapRegionId? regionIdForSvgFill(String hexUpper) {
    switch (hexUpper.toUpperCase()) {
      case '8481CA':
        return MapRegionId.marmara;
      case 'CA8181':
        return MapRegionId.aegean;
      case '81CABE':
        return MapRegionId.mediterranean;
      case 'A6CA81':
        return MapRegionId.centralAnatolia;
      case '81ACCA':
        return MapRegionId.blackSea;
      case '81CA84':
        return MapRegionId.easternAnatolia;
      case 'CA81BB':
        return MapRegionId.southeastAnatolia;
      default:
        return null;
    }
  }

  static final Map<MapRegionId, List<VictimRecord>> victimsByRegion = {
    MapRegionId.marmara: [
      VictimRecord(
        fullName: 'Алексей Марков',
        birthDate: DateTime(1912, 3, 14),
        deathDate: DateTime(1938, 11, 2),
      ),
      VictimRecord(
        fullName: 'Елена Савич',
        birthDate: DateTime(1905, 7, 22),
        deathDate: DateTime(1937, 8, 19),
      ),
    ],
    MapRegionId.aegean: [
      VictimRecord(
        fullName: 'Дмитрий Орлов',
        birthDate: DateTime(1899, 1, 5),
        deathDate: DateTime(1938, 4, 12),
      ),
      VictimRecord(
        fullName: 'Мария Петрова',
        birthDate: DateTime(1910, 9, 30),
        deathDate: DateTime(1937, 12, 1),
      ),
      VictimRecord(
        fullName: 'Иван Крылов',
        birthDate: DateTime(1901, 11, 18),
        deathDate: DateTime(1939, 2, 28),
      ),
    ],
    MapRegionId.mediterranean: [
      VictimRecord(
        fullName: 'Софья Рейн',
        birthDate: DateTime(1908, 5, 9),
        deathDate: DateTime(1937, 6, 14),
      ),
    ],
    MapRegionId.centralAnatolia: [
      VictimRecord(
        fullName: 'Николай Верин',
        birthDate: DateTime(1894, 2, 27),
        deathDate: DateTime(1938, 9, 3),
      ),
      VictimRecord(
        fullName: 'Ольга Нестерова',
        birthDate: DateTime(1915, 4, 11),
        deathDate: DateTime(1937, 10, 20),
      ),
    ],
    MapRegionId.blackSea: [
      VictimRecord(
        fullName: 'Григорий Амиров',
        birthDate: DateTime(1903, 8, 16),
        deathDate: DateTime(1937, 7, 7),
      ),
      VictimRecord(
        fullName: 'Татьяна Лукина',
        birthDate: DateTime(1911, 12, 3),
        deathDate: DateTime(1938, 1, 15),
      ),
    ],
    MapRegionId.easternAnatolia: [
      VictimRecord(
        fullName: 'Андрей Соколов',
        birthDate: DateTime(1897, 6, 21),
        deathDate: DateTime(1937, 3, 29),
      ),
      VictimRecord(
        fullName: 'Вера Ким',
        birthDate: DateTime(1906, 10, 8),
        deathDate: DateTime(1939, 5, 4),
      ),
      VictimRecord(
        fullName: 'Пётр Захаров',
        birthDate: DateTime(1900, 1, 1),
        deathDate: DateTime(1938, 8, 22),
      ),
    ],
    MapRegionId.southeastAnatolia: [
      VictimRecord(
        fullName: 'Лидия Морозова',
        birthDate: DateTime(1913, 2, 17),
        deathDate: DateTime(1937, 11, 11),
      ),
    ],
  };

  static List<RegionVictimCount> buildRegionCounts() {
    final ids = MapRegionId.values;
    return [
      for (final id in ids)
        RegionVictimCount(
          id: id,
          displayName: regionName(id),
          colorArgb: regionColor(id),
          count: victimsByRegion[id]?.length ?? 0,
        ),
    ];
  }

  static RegionalMapSummary buildSummary() {
    final counts = buildRegionCounts();
    final total = counts.fold<int>(0, (s, r) => s + r.count);
    final n = counts.length;
    final avg = n == 0 ? 0.0 : total / n;
    return RegionalMapSummary(
      totalVictims: total,
      regionCount: n,
      averageVictimsPerRegion: avg,
    );
  }
}
