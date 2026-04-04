import 'package:project_temp/features/home/domain/map_region_id.dart';

/// Сводка по карте (агрегаты по мок-данным).
class RegionalMapSummary {
  const RegionalMapSummary({
    required this.totalVictims,
    required this.regionCount,
    required this.averageVictimsPerRegion,
  });

  final int totalVictims;
  final int regionCount;
  final double averageVictimsPerRegion;
}

/// Счётчик по одному региону (для легенды).
class RegionVictimCount {
  const RegionVictimCount({
    required this.id,
    required this.displayName,
    required this.colorArgb,
    required this.count,
  });

  final MapRegionId id;
  final String displayName;
  final int colorArgb;
  final int count;
}
