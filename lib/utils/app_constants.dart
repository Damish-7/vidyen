// lib/utils/app_constants.dart
abstract class AppConstants {
  static const String appName = 'VIDYEN';
  static const String appTagline = 'Conference Portal';

  // SharedPreferences keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // API base (update when backend is ready)
  static const String baseUrl = 'https://api.vidyen.com/v1';
}