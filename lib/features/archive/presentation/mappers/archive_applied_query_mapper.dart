import 'package:flutter/widgets.dart';

import 'package:project_temp/source/source.dart';

/// Снимок текстовых полей фильтра → доменная модель запроса.
ArchiveCatalogAppliedQuery archiveAppliedQueryFromControllers({
  required TextEditingController fullName,
  required TextEditingController accusation,
  required TextEditingController yearFrom,
  required TextEditingController yearTo,
  required TextEditingController punishment,
  required TextEditingController region,
  required TextEditingController punishmentDate,
  required TextEditingController occupation,
  required TextEditingController rehabDate,
}) {
  return ArchiveCatalogAppliedQuery(
    fullName: fullName.text,
    accusation: accusation.text,
    yearFrom: yearFrom.text,
    yearTo: yearTo.text,
    punishment: punishment.text,
    region: region.text,
    punishmentDate: punishmentDate.text,
    occupation: occupation.text,
    rehabDate: rehabDate.text,
  );
}
