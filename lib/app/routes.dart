import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/core/storage/secure_storage.dart';
import 'package:task_management/src/data/model/task_model.dart';
import 'package:task_management/src/presentation/screens/auth/controller/auth_controller.dart';
import 'package:task_management/src/presentation/screens/auth/view/auth_lisanable.dart';
import 'package:task_management/src/presentation/screens/auth/view/mobile/auth_login.dart';
import 'package:task_management/src/presentation/screens/task/form/view/task_form_view.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';
import 'package:task_management/src/presentation/screens/task/list/view/task_list_view.dart';

class Routes {
  late final GoRouter router;

  final AuthController auth = getIt<AuthController>();

  Routes() {
    router = GoRouter(
      initialLocation: '/',

      routes: [
        GoRoute(
          path: RouteName.login,
          name: RouteName.login,
          builder: (context, state) => AuthLoginPage(),
        ),

        GoRoute(
          path: RouteName.taskmanagement,
          name: RouteName.taskmanagement,
          builder: (context, state) {
            final repository = getIt<TaskRepository>();

            return TaskListView(repository: repository);
          },
        ),
        GoRoute(
          path: RouteName.addtask,
          name: RouteName.addtask,
          builder: (context, state) {
            final repository = getIt<TaskRepository>();

            final task = state.extra is TaskModel
                ? state.extra as TaskModel
                : null;
            return TaskFormView(repository: repository, task: task);
          },
        ),
      ],
      refreshListenable: AuthListenable(auth),

      redirect: (context, state) async {
        final loggedIn = auth.isLoggedIn;
        final storage = SecureStorageService();
        final token = await storage.getToken();

        final loggingIn = state.matchedLocation == RouteName.login;

        if (!loggedIn && token == null) {
          return loggingIn ? null : RouteName.login;
        }

        if (loggingIn && token != null) {
          return RouteName.taskmanagement;
        }

        return null;
      },
    );
  }
}
