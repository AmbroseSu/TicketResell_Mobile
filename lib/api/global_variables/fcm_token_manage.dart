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
  }
}