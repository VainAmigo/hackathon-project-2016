import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/features/home/domain/regional_map_summary.dart';
import 'package:project_temp/features/home/domain/victim_record.dart';

/// Источник данных по жертвам по регионам (сейчас — статический мок).
abstract class RegionalVictimsRepository {
  RegionalMapSummary get summary;

  List<RegionVictimCount> get regionCounts;

  List<VictimRecord> victimsFor(MapRegionId regionId);
}
