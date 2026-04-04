import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/features/home/domain/regional_map_summary.dart'
    show RegionalMapSummary, RegionVictimCount;
import 'package:project_temp/features/home/domain/victim_record.dart';

/// Статические мок-данные: цвета SVG (заливки path) и списки жертв по областям КР.
abstract final class RegionalVictimsMockData {
  static const int colorChuy = 0xFF8481CA;
  static const int colorTalas = 0xFFCA8181;
  static const int colorNaryn = 0xFF81CABE;
  static const int colorBatken = 0xFFA6CA81;
  static const int colorOsh = 0xFF81ACCA;
  static const int colorIssykKul = 0xFF81CA84;
  static const int colorJalalAbad = 0xFFCA81BB;

  static int regionColor(MapRegionId id) {
    switch (id) {
      case MapRegionId.chuy:
        return colorChuy;
      case MapRegionId.talas:
        return colorTalas;
      case MapRegionId.naryn:
        return colorNaryn;
      case MapRegionId.batken:
        return colorBatken;
      case MapRegionId.osh:
        return colorOsh;
      case MapRegionId.issykKul:
        return colorIssykKul;
      case MapRegionId.jalalAbad:
        return colorJalalAbad;
    }
  }

  /// Hex заливки в SVG → область (см. [assets/images/map.svg]).
  static MapRegionId? regionIdForSvgFill(String hexUpper) {
    switch (hexUpper.toUpperCase()) {
      case '8481CA':
        return MapRegionId.chuy;
      case 'CA8181':
        return MapRegionId.talas;
      case '81CABE':
        return MapRegionId.naryn;
      case 'A6CA81':
        return MapRegionId.batken;
      case '81ACCA':
        return MapRegionId.osh;
      case '81CA84':
        return MapRegionId.issykKul;
      case 'CA81BB':
        return MapRegionId.jalalAbad;
      default:
        return null;
    }
  }

  static final Map<MapRegionId, List<VictimRecord>> victimsByRegion = {
    MapRegionId.chuy: [
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
    MapRegionId.talas: [
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
    MapRegionId.naryn: [
      VictimRecord(
        fullName: 'Софья Рейн',
        birthDate: DateTime(1908, 5, 9),
        deathDate: DateTime(1937, 6, 14),
      ),
    ],
    MapRegionId.batken: [
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
    MapRegionId.osh: [
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
    MapRegionId.issykKul: [
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
    MapRegionId.jalalAbad: [
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
