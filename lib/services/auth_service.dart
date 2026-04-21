// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final result = await _api.post('/auth/login', {
      'identifier': identifier,
      'password':   password,
    }, auth: false);

    if (result['success'] == true) {
      final token = result['data']['token'] as String;
      final user  = UserModel.fromJson(result['data']['user']);
      await _saveSession(token, user);
      return {'success': true, 'user': user};
    }
    return {'success': false, 'message': result['message'] ?? 'Login failed.'};
  }

  // ── Register ───────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String username,
    required String password,
    String? designation,
    String? institution,
  }) async {
    final result = await _api.post('/auth/register', {
      'name':        name,
      'email':       email,
      'username':    username,
      'password':    password,
      'designation': designation ?? '',
      'institution': institution ?? '',
    }, auth: false);

    return {
      'success': result['success'] == true,
      'message': result['message'] ?? '',
    };
  }

  // ── Session ────────────────────────────────────────────────────────────────
  Future<void> _saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey,  token);
    await prefs.setString(AppConstants.userKey,   jsonEncode(user.toJson()));
    await prefs.setBool(AppConstants.isLoggedKey, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isLoggedKey) ?? false;
  }

  Future<UserModel?> getCachedUser() async {
    final prefs   = await SharedPreferences.getInstance();
    final userStr = prefs.getString(AppConstants.userKey);
    if (userStr == null) return null;
    return UserModel.fromJson(jsonDecode(userStr));
  }

  Future<UserModel?> fetchCurrentUser() async {
    final result = await _api.get('/auth/me');
    if (result['success'] == true) {
      final user = UserModel.fromJson(result['data']);
      // Refresh cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
      return user;
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    await prefs.setBool(AppConstants.isLoggedKey, false);
  }
}