/// Идентификаторы секций-плейсхолдеров под hero (порядок = порядок на экране).
enum HomePlaceholderSectionId {
  archiveMaterials,
  stories,
  projectHelp,
  legal,
}

extension HomePlaceholderSectionIdX on HomePlaceholderSectionId {
  bool get alternateBackground => index.isOdd;
}

const List<HomePlaceholderSectionId> kHomePlaceholderSectionOrder =
    HomePlaceholderSectionId.values;
