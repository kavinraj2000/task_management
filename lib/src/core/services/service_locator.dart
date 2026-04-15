import 'package:get_it/get_it.dart';
import 'package:task_management/src/core/storage/secure_storage.dart';
import 'package:task_management/src/feature/auth/repo/auth_repo.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';

final getIt = GetIt.instance;

Future<void> serviceLocator() async {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

 getIt.registerLazySingleton<AuthController>(
    () => AuthController(
      repo: getIt(),
      storage: getIt(),
    ),
  );
}
