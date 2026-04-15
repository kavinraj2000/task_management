import 'dart:convert';
import 'package:get/get.dart';
import 'package:task_management/src/core/storage/secure_storage.dart';
import 'package:task_management/src/data/model/user_model.dart';
import 'package:task_management/src/feature/auth/repo/auth_repo.dart';

enum AuthStatus { initial, loading, success, error, refreshing }

class AuthController extends GetxController {
  final AuthRepository repo;
  final SecureStorageService storage;

  AuthController({required this.repo, required this.storage});

  Rxn<UserModel> user = Rxn<UserModel>();

  Rx<AuthStatus> status = AuthStatus.initial.obs;
  RxString errorMessage = ''.obs;

  Future<void> login(String email, String password) async {
    status.value = AuthStatus.loading;
    errorMessage.value = '';

    try {
      final result = await repo.login(email, password);

      final userModel = UserModel.fromJson(result);

      user.value = userModel;

      await storage.saveUser(jsonEncode(result));

      status.value = AuthStatus.success;
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = "Login failed";
    }
  }

  Future<void> signin(String email, String password) async {
    status.value = AuthStatus.loading;
    errorMessage.value = '';

    try {
      final result = await repo.signin(email, password);

      final userModel = UserModel.fromJson(result);

      user.value = userModel;

      await storage.saveUser(jsonEncode(result));

      status.value = AuthStatus.success;
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = "Signin failed";
    }
  }

  Future<void> logout() async {
    status.value = AuthStatus.loading;

    try {
      user.value = null;
      await storage.clear();

      status.value = AuthStatus.initial;
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = "Logout failed";
    }
  }

  Future<void> checkAuth() async {
    status.value = AuthStatus.loading;

    final data = await storage.getUser();

    if (data == null) {
      status.value = AuthStatus.initial;
      return;
    }

    final userModel = UserModel.fromJson(jsonDecode(data));

    user.value = userModel;

    if (userModel.isTokenExpired) {
      await logout();
    } else {
      status.value = AuthStatus.success;
    }
  }

  // ---------------- GETTERS ----------------
  bool get isLoggedIn => user.value != null;

  bool get isLoading => status.value == AuthStatus.loading;
}
