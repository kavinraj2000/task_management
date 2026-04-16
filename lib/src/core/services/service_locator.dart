import 'package:get_it/get_it.dart';
import 'package:task_management/src/core/network/dio_client.dart';
import 'package:task_management/src/core/storage/secure_storage.dart';
import 'package:task_management/src/data/database/local_datasource.dart';
import 'package:task_management/src/data/database/local_db.dart';
import 'package:task_management/src/data/repository/prefernces_repo.dart';
import 'package:task_management/src/data/repository/task_repo_implmet.dart';
import 'package:task_management/src/presentation/screens/auth/repo/auth_repo.dart';
import 'package:task_management/src/presentation/screens/auth/controller/auth_controller.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';

final getIt = GetIt.instance;

Future<void> serviceLocator() async {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(storage: getIt<SecureStorageService>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<DioClient>(), getIt<PreferencesRepo>()),
  );

  getIt.registerLazySingleton<PreferencesRepo>(() => PreferencesRepo());

  getIt.registerLazySingleton<LocalDb>(() => LocalDb.instance);

  getIt.registerLazySingleton<LocalDataSource>(
    () => LocalDataSource(getIt<LocalDb>()),
  );

  getIt.registerLazySingleton<AuthController>(
    () => AuthController(
      repo: getIt<AuthRepository>(),
      pref: getIt<PreferencesRepo>(),
    ),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      dio: getIt<DioClient>().dio, 
      local: getIt<LocalDataSource>(),
    ),
  );
}
