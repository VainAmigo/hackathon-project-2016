/// Плейсхолдер-блоки под hero (данные без Flutter).
final class HomePlaceholderSectionData {
  const HomePlaceholderSectionData({
    required this.title,
    required this.subtitle,
    required this.alternateBackground,
  });

  final String title;
  final String subtitle;
  final bool alternateBackground;
}

/// Порядок и содержимое секций — единая точка правды.
const List<HomePlaceholderSectionData> kHomePlaceholderSections = [
  HomePlaceholderSectionData(
    title: 'Материалы архива',
    subtitle: 'Здесь будет каталог документов, записей и воспоминаний.',
    alternateBackground: false,
  ),
  HomePlaceholderSectionData(
    title: 'Истории и свидетельства',
    subtitle: 'Раздел для личных историй и связанных с ними материалов.',
    alternateBackground: true,
  ),
  HomePlaceholderSectionData(
    title: 'Как помочь проекту',
    subtitle: 'Плейсхолдер: волонтёрство, пожертвования, распространение.',
    alternateBackground: false,
  ),
  HomePlaceholderSectionData(
    title: 'Контакты и правовая информация',
    subtitle: 'Плейсхолдер: реквизиты, политика конфиденциальности, связь.',
    alternateBackground: true,
  ),
];
