import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/data/archive_catalog_repository_impl.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_repository.dart';
import 'package:project_temp/source/source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

/// [testMode]: in-memory secure storage (без Keychain/Keystore).
Future<void> initDependencies({bool testMode = false}) async {
  await sl.reset();

  final sharedPrefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton<SharedPreferences>(sharedPrefs)
    ..registerLazySingleton<LocalePreferences>(
      () => LocalePreferences(sharedPrefs),
    );

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
    )
    ..registerLazySingleton<ArchiveCatalogRepository>(
      ArchiveCatalogRepositoryImpl.new,
    );
}
