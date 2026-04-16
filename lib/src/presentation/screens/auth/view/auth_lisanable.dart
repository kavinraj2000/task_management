import 'package:flutter/foundation.dart';
import 'package:task_management/src/presentation/screens/auth/controller/auth_controller.dart';

class AuthListenable extends ChangeNotifier {
  final AuthController auth;

  AuthListenable(this.auth) {
    auth.user.listen((_) {
      notifyListeners();
    });

    auth.status.listen((_) {
      notifyListeners();
    });
  }
}
