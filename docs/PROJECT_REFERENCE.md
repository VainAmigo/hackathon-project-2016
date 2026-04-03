# Справочник (упрощённая структура)

## Слои

- **`lib/models/`** — `User` (JsonSerializable), `LoginResult` (разбор ответа логина).
- **`lib/domain/`** — `Failure` + абстрактный `AuthRepository`.
- **`lib/data/`** — `AuthRepositoryImpl`: один `post` через `DioClient.publicDio`, сохранение токенов.
- **`lib/core/`** — Dio, интерцепторы, логгер, `PreferencesService` (только access/refresh токены, без кэша профиля).
- **`lib/features/`** — `AuthGate`, `LoginPage`, `HomePage`.

## Запрос логина

Всё в `AuthRepositoryImpl.login`: `ApiEndpoints.login`, тело `{ phoneNumber, password }`, ответ → `LoginResult.fromJson`.

## Сессия

После входа `User` передаётся в `AuthGate` в памяти. После перезапуска при наличии токена профиль на экране не восстанавливается (кэша нет) — показывается пояснение на главной.

## Кодогенерация

```bash
dart run build_runner build --delete-conflicting-outputs
```

Генерируется `lib/models/user.g.dart`.
