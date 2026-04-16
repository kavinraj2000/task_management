import 'dart:convert';
import 'package:get/get.dart';
import 'package:task_management/src/data/model/user_model.dart';
import 'package:task_management/src/data/repository/prefernces_repo.dart';
import 'package:task_management/src/feature/auth/repo/auth_repo.dart';

enum AuthStatus { initial, loading, success, error }

class AuthController extends GetxController {
  final AuthRepository repo;
  final PreferencesRepo storage;

  AuthController({required this.repo, required this.storage});

  Rxn<UserModel> user = Rxn<UserModel>();
  Rx<AuthStatus> status = AuthStatus.initial.obs;
  RxString errorMessage = ''.obs;

  Future<void> login(String email, String password) async {
    status.value = AuthStatus.loading;
    errorMessage.value = '';

    try {
      final result = await repo.login(email, password);

      final userModel = UserModel.fromJson(result.toJson());

      user.value = userModel;


      status.value = AuthStatus.success;
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = e.toString();
    }
  }
  Future<void> signin(String email, String password) async {
    status.value = AuthStatus.loading;
    errorMessage.value = '';

    try {
      final result = await repo.signin(email, password);

      final userModel = UserModel.fromJson(result.toJson());

      user.value = userModel;


      status.value = AuthStatus.success;
    } catch (e) {
      status.value = AuthStatus.error;
      errorMessage.value = e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await repo.logout();
    } catch (_) {}

    await storage.clear();
    user.value = null;
    status.value = AuthStatus.initial;
  }

  Future<void> checkAuth() async {
    status.value = AuthStatus.loading;

    final data = await storage.getUser();

    if (data == null) {
      user.value = null;
      status.value = AuthStatus.initial;
      return;
    }

    final userModel = UserModel.fromJson(jsonDecode(data));

    if (userModel.isTokenExpired) {
      await logout();
      return;
    }

    user.value = userModel;
    status.value = AuthStatus.success;
  }

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool get isLoggedIn => user.value != null;
  bool get isLoading => status.value == AuthStatus.loading;
}
