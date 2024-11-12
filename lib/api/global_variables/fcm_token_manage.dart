import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();

  String? _fcmToken;

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  String? get fcmToken => _fcmToken;

  set fcmToken(String? token) {
    _fcmToken = token;
    // _saveToPrefs('token', token);
  }

  // Future<void> _saveToPrefs(String key, dynamic value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (value is String) {
  //     prefs.setString(key, value);
  //   } else if (value is int) {
  //     prefs.setInt(key, value);
  //   }
  // }
  //
  // Future<void> loadFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _fcmToken = prefs.getString('token');
  //
  // }
  //
  // Future<void> clearUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   _fcmToken = null;
  // }
}