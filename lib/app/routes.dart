import 'package:go_router/go_router.dart';
import 'package:task_management/app/route_name.dart';
import 'package:task_management/src/core/services/service_locator.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';
import 'package:task_management/src/feature/auth/view/mobile/auth_login.dart';

class Routes {
  late final GoRouter router;

  Routes() {
    router = GoRouter(
      initialLocation: RouteName.login,

      redirect: (context, state) {
        final auth = getIt<AuthController>();

        final loggedIn = auth.isLoggedIn;
        final loggingIn = state.matchedLocation == RouteName.login;

        if (!loggedIn) {
          return loggingIn ? null : RouteName.login;
        }

        if (loggingIn) {
          return RouteName.home;
        }

        return null;
      },

      routes: [
        GoRoute(
          path: RouteName.login,
          builder: (context, state) =>  AuthLoginPage(),
        ),

        // GoRoute(
        //   path: RouteName.home,
        //   builder: (context, state) => const HomePage(),
        // ),
      ],
    );
  }
}