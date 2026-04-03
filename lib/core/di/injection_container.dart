import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

final sl = GetIt.instance;

/// [testMode]: in-memory secure storage (без Keychain/Keystore).
Future<void> initDependencies({bool testMode = false}) async {
  await sl.reset();

  if (testMode) {
    sl.registerLazySingleton<SecureStorage>(InMemorySecureStorage.new);
  } else {
    sl
      ..registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        ),
      )
      ..registerLazySingleton<SecureStorage>(
        () => FlutterSecureStorageAdapter(sl()),
      );
  }

  sl
    ..registerLazySingleton<AppLogger>(AppLogger.new)
    ..registerLazySingleton<PreferencesService>(
      () => PreferencesServiceImpl(secureStorage: sl()),
    )
    ..registerLazySingleton<DioClient>(
      () => DioClient(preferencesService: sl(), logger: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        dioClient: sl(),
        preferences: sl(),
      ),
    );
}
