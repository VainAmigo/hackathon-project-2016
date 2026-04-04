import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/features/home/domain/regional_map_summary.dart';
import 'package:project_temp/features/home/domain/regional_victims_repository.dart';
import 'package:project_temp/features/home/domain/victim_record.dart';
import 'package:project_temp/features/home/data/regional_victims_mock_data.dart';

class RegionalVictimsRepositoryImpl implements RegionalVictimsRepository {
  RegionalVictimsRepositoryImpl();

  late final RegionalMapSummary _summary =
      RegionalVictimsMockData.buildSummary();
  late final List<RegionVictimCount> _counts =
      RegionalVictimsMockData.buildRegionCounts();

  @override
  RegionalMapSummary get summary => _summary;

  @override
  List<RegionVictimCount> get regionCounts => _counts;

  @override
  List<VictimRecord> victimsFor(MapRegionId regionId) {
    return List<VictimRecord>.unmodifiable(
      RegionalVictimsMockData.victimsByRegion[regionId] ?? const [],
    );
  }
}
