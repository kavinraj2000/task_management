import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _key = "user_token";

  Future<void> saveUser(String json) async {
    await _storage.write(key: _key, value: json);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: _key);
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
