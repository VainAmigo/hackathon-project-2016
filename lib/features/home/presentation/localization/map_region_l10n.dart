import 'package:project_temp/features/home/domain/map_region_id.dart';
import 'package:project_temp/l10n/app_localizations.dart';

extension MapRegionIdL10n on AppLocalizations {
  String mapRegionLabel(MapRegionId id) {
    switch (id) {
      case MapRegionId.chuy:
        return homeMapRegionChuy;
      case MapRegionId.talas:
        return homeMapRegionTalas;
      case MapRegionId.naryn:
        return homeMapRegionNaryn;
      case MapRegionId.batken:
        return homeMapRegionBatken;
      case MapRegionId.osh:
        return homeMapRegionOsh;
      case MapRegionId.issykKul:
        return homeMapRegionIssykKul;
      case MapRegionId.jalalAbad:
        return homeMapRegionJalalAbad;
    }
  }
}
