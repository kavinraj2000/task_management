import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:task_management/src/core/constants/constants.dart';
import 'package:task_management/src/data/repository/mock_api_repo.dart';

class AuthRepository {
  final Dio dio = Dio();
  final MockApiRepo baseapi = MockApiRepo();

  AuthRepository();

  final _uuid = const Uuid();

  Future<Map<String, dynamic>> signin(String email, String password) async {
    try {
      final response = await dio.post(
        '${baseapi.baseurl}${Constants.api.login}',
        data: {'email': email, 'password': password},
        options: Options(headers: {'content-type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> result = Map<String, dynamic>.from(data);

        result['token'] ??= _uuid.v4();

        result['tokenExpiry'] ??= DateTime.now()
            .add(const Duration(minutes: 30))
            .toIso8601String();

        result['email'] = email;

        return result;
      } else {
        throw Exception('Signin failed');
      }
    } catch (e) {
      throw Exception('Signin error: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return signin(email, password);
  }

  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> user) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      ...user,
      "token": _uuid.v4(),
      "tokenExpiry": DateTime.now()
          .add(const Duration(minutes: 10))
          .toIso8601String(),
    };
  }
}
