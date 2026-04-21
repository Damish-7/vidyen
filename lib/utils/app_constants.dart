// lib/utils/app_constants.dart
abstract class AppConstants {
  static const String appName    = 'VIDYEN';
  static const String appTagline = 'Conference Portal';

  // ── MAMP local server ──────────────────────────────────────────────────────
  // Change this to your machine IP when testing on a physical device
  // e.g. 'http://192.168.1.x:8888/vidyen_api'
  static const String baseUrl = 'http://localhost:8888/vidyen_api';

  // SharedPreferences keys (only for token + basic user cache)
  static const String tokenKey    = 'auth_token';
  static const String userKey     = 'user_data';
  static const String isLoggedKey = 'is_logged_in';
}