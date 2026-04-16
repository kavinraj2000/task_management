import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:task_management/src/feature/auth/controller/auth_controller.dart';

class AuthListenable extends ChangeNotifier {
  final AuthController auth;

  AuthListenable(this.auth) {
    ever(auth.status, (_) {
      notifyListeners();
    });
  }
}