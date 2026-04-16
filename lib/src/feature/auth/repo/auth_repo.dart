import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:task_management/src/core/network/dio_client.dart';
import 'package:task_management/src/core/constants/constants.dart';
import 'package:task_management/src/data/model/user_model.dart';
import 'package:task_management/src/data/repository/mock_api_repo.dart';
import 'package:task_management/src/data/repository/prefernces_repo.dart';

class AuthRepository {
  final DioClient _dioClient;
  final MockApiRepo _api = MockApiRepo();
  final PreferencesRepo _pref;
  final Logger _log = Logger();
  final Uuid _uuid = const Uuid();

  AuthRepository(
    this._dioClient,
    this._pref,
  );

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.get(
        '${_api.baseurl}${Constants.api.auth}',
        queryParameters: {'email': email},
      );

      final data = _validateListResponse(response.data);

      final userData = data.first;

      final userMap = _normalizeUser(userData, email);

      final user = UserModel.fromJson(userMap);

      await _saveSession(user);

      return user;
    } on DioException catch (e) {
      _log.e("Login DioException: ${e.message}");
      throw Exception(_extractError(e));
    } catch (e) {
      _log.e("Login Error: $e");
      throw Exception("Login failed");
    }
  }

  Future<UserModel> signin(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '${_api.baseurl}${Constants.api.auth}',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = _validateMapResponse(response.data);

      final userMap = _normalizeUser(data, email);

      final user = UserModel.fromJson(userMap);

      await _saveSession(user);

      return user;
    } on DioException catch (e) {
      _log.e("Signin DioException: ${e.message}");
      throw Exception(_extractError(e));
    } catch (e) {
      _log.e("Signin Error: $e");
      throw Exception("Signin failed");
    }
  }

  Future<void> logout() async {
    try {
      await _dioClient.storage.clear();
      await _pref.clear();
    } catch (e) {
      _log.e("Logout error: $e");
    }
  }

  Future<UserModel> refreshToken(UserModel user) async {
    try {
      final updated = user.copyWith(
        token: _uuid.v4(),
        tokenExpiry: DateTime.now().add(const Duration(minutes: 30)),
      );

      await _saveSession(updated);

      return updated;
    } catch (e) {
      throw Exception("Token refresh failed");
    }
  }



  Future<void> _saveSession(UserModel user) async {
    await _pref.saveUser(jsonEncode(user.toJson()));

    await _dioClient.storage.saveToken(
      user.token,
      user.tokenExpiry.toIso8601String(),
    );

    _log.d("User session saved");
  }

  Map<String, dynamic> _normalizeUser(
    Map<String, dynamic> data,
    String email,
  ) {
    return {
      ...data,
      "email": email,
      "token": data['token'] ?? _uuid.v4(),
      "tokenExpiry": data['tokenExpiry'] ??
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
    };
  }

  List _validateListResponse(dynamic data) {
    if (data is List && data.isNotEmpty) return data;
    throw Exception("Invalid response format (expected List)");
  }

  Map<String, dynamic> _validateMapResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw Exception("Invalid response format (expected Map)");
  }

  String _extractError(DioException e) {
    return e.response?.data?['message'] ??
        e.message ??
        "Network error";
  }
}