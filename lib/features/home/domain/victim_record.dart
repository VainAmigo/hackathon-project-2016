/// Упрощённая карточка жертвы для регионального раздела (мок).
class VictimRecord {
  VictimRecord({
    required this.fullName,
    required this.birthDate,
    required this.deathDate,
  });

  final String fullName;
  final DateTime birthDate;
  final DateTime deathDate;
}
