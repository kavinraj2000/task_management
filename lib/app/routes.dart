import 'package:go_router/go_router.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';
import 'package:task_management/src/feature/auth/view/auth_lisanable.dart';
import 'package:task_management/src/feature/auth/view/mobile/auth_login.dart';
import 'package:task_management/src/feature/auth/view/mobile/auth_signin.dart';
import 'package:task_management/src/presentation/screens/task/repo/task_repo.dart';
import 'package:task_management/src/presentation/screens/task/list/view/task_list_view.dart';

class Routes {
  late final GoRouter router;

  final AuthController auth = getIt<AuthController>();

  Routes() {
    router = GoRouter(
      initialLocation: RouteName.taskmanagement,

      routes: [
        GoRoute(
          path: RouteName.login,
          name: RouteName.login,
          builder: (context, state) => AuthLoginPage(),
        ),
        GoRoute(
          path: RouteName.signin,
          name: RouteName.signin,
          builder: (context, state) => AuthSignInPage(),
        ),

        GoRoute(
          path: RouteName.taskmanagement,
          name: RouteName.taskmanagement,
          builder: (context, state) {
            final repository = getIt<TaskRepository>();

            return TaskListView(repository: repository);
          },
        ),
      ],
      refreshListenable: AuthListenable(auth),

      redirect: (context, state) {
        final loggedIn = auth.isLoggedIn;
        final loggingIn =
            state.matchedLocation == RouteName.login ||
            state.matchedLocation == RouteName.signin;

        if (!loggedIn) {
          return loggingIn ? null : RouteName.login;
        }

        if (loggingIn) {
          return RouteName.taskmanagement; // make sure home route exists
        }

        return null;
      },
    );
  }
}
