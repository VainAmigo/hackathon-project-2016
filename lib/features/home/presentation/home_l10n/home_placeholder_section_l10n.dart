import 'package:project_temp/features/home/domain/home_placeholder_catalog.dart';
import 'package:project_temp/l10n/app_localizations.dart';

extension HomePlaceholderSectionIdL10n on HomePlaceholderSectionId {
  String title(AppLocalizations l) => switch (this) {
        HomePlaceholderSectionId.archiveMaterials =>
          l.homeSectionArchiveTitle,
        HomePlaceholderSectionId.stories => l.homeSectionStoriesTitle,
        HomePlaceholderSectionId.projectHelp => l.homeSectionHelpTitle,
        HomePlaceholderSectionId.legal => l.homeSectionLegalTitle,
      };

  String subtitle(AppLocalizations l) => switch (this) {
        HomePlaceholderSectionId.archiveMaterials =>
          l.homeSectionArchiveSubtitle,
        HomePlaceholderSectionId.stories => l.homeSectionStoriesSubtitle,
        HomePlaceholderSectionId.projectHelp => l.homeSectionHelpSubtitle,
        HomePlaceholderSectionId.legal => l.homeSectionLegalSubtitle,
      };
}
