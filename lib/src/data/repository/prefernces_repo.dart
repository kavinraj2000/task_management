import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepo {
  static const _keyUserToken = "user_token";

  Future<void> saveUser(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserToken, token);
  }

  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserToken);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserToken);
  }
}
