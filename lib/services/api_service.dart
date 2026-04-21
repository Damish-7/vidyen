// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _base = AppConstants.baseUrl;

  // ── Token management ───────────────────────────────────────────────────────
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ── Core request methods ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> get(String path) async {
    try {
      final res = await http.get(
        Uri.parse('$_base$path'),
        headers: await _headers(),
      ).timeout(const Duration(seconds: 15));
      return _parse(res);
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body,
      {bool auth = true}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base$path'),
        headers: await _headers(auth: auth),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
      return _parse(res);
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    try {
      final res = await http.put(
        Uri.parse('$_base$path'),
        headers: await _headers(),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
      return _parse(res);
    } catch (e) {
      return _networkError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final res = await http.delete(
        Uri.parse('$_base$path'),
        headers: await _headers(),
      ).timeout(const Duration(seconds: 15));
      return _parse(res);
    } catch (e) {
      return _networkError(e);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Map<String, dynamic> _parse(http.Response res) {
    try {
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      return decoded;
    } catch (_) {
      return {'success': false, 'message': 'Invalid server response.'};
    }
  }

  Map<String, dynamic> _networkError(Object e) {
    return {'success': false, 'message': 'Network error. Check your connection and MAMP server.'};
  }
}