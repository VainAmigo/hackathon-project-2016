String stringIdFromJson(Object? value) => value?.toString() ?? '';

int? personIdFromJson(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

/// Целочисленный id из JSON (чаты, documentId в источниках).
int apiIntIdFromJson(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  final p = int.tryParse(value?.toString() ?? '');
  if (p == null) {
    throw FormatException('Некорректный целочисленный id', value);
  }
  return p;
}

DateTime apiDateTimeFromJson(Object? value) {
  if (value is String) {
    final d = DateTime.tryParse(value);
    if (d != null) return d;
  }
  throw FormatException('Ожидалась дата в формате ISO8601', value);
}
