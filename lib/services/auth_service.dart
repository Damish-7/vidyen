// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class AuthService {
  // ── Login ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String identifier, // email or username
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await _saveSession(data['token'], data['user']);
        return {'success': true, 'user': UserModel.fromJson(data['user'])};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
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
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'username': username,
          'password': password,
          'designation': designation,
          'institution': institution,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'Registration successful'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // ── Session ────────────────────────────────────────────────────────────────
  Future<void> _saveSession(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
    await prefs.setBool(AppConstants.isLoggedInKey, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    await prefs.setBool(AppConstants.isLoggedInKey, false);
  }
}