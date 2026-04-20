// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../models/hive_models/user_hive_model.dart';
import '../models/hive_models/session_hive_model.dart';
import '../models/hive_models/settings_hive_model.dart';
import '../utils/hive_boxes.dart';

class AuthService {
  Box<UserHiveModel> get _usersBox =>
      Hive.box<UserHiveModel>(HiveBoxes.users);
  Box<SessionHiveModel> get _sessionBox =>
      Hive.box<SessionHiveModel>(HiveBoxes.session);
  Box<SettingsHiveModel> get _settingsBox =>
      Hive.box<SettingsHiveModel>(HiveBoxes.settings);

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _hashPassword(String password) {
    final bytes = utf8.encode(password + 'vidyen_salt_2024');
    return sha256.convert(bytes).toString();
  }

  String _generateToken() {
    final rand = Random.secure();
    final values = List<int>.generate(32, (_) => rand.nextInt(256));
    return base64Url.encode(values);
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network

    final id = identifier.trim().toLowerCase();
    final hash = _hashPassword(password);

    // Find user by email or username
    UserHiveModel? user;
    for (final u in _usersBox.values) {
      if (u.email.toLowerCase() == id || (u.username?.toLowerCase() == id)) {
        user = u;
        break;
      }
    }

    if (user == null) {
      return {'success': false, 'message': 'No account found with that email or username.'};
    }

    if (user.passwordHash != hash) {
      return {'success': false, 'message': 'Incorrect password. Please try again.'};
    }

    // Save session
    final token = _generateToken();
    final session = SessionHiveModel(
      userId: user.id,
      token: token,
      loginAt: DateTime.now(),
      isLoggedIn: true,
    );
    await _sessionBox.put('current', session);

    return {'success': true, 'user': user};
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
    await Future.delayed(const Duration(milliseconds: 800));

    final emailLower = email.trim().toLowerCase();
    final usernameLower = username.trim().toLowerCase();

    // Check duplicates
    for (final u in _usersBox.values) {
      if (u.email.toLowerCase() == emailLower) {
        return {'success': false, 'message': 'An account with this email already exists.'};
      }
      if (u.username?.toLowerCase() == usernameLower) {
        return {'success': false, 'message': 'This username is already taken.'};
      }
    }

    final id = 'usr_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = UserHiveModel(
      id: id,
      name: name.trim(),
      email: emailLower,
      username: usernameLower,
      designation: designation?.trim(),
      institution: institution?.trim(),
      passwordHash: _hashPassword(password),
    );

    await _usersBox.put(id, newUser);

    // Init settings for new user
    if (_settingsBox.get('app_settings') == null) {
      await _settingsBox.put(
        'app_settings',
        SettingsHiveModel(lastSyncAt: DateTime.now()),
      );
    }

    return {'success': true, 'message': 'Account created successfully!'};
  }

  // ── Session ────────────────────────────────────────────────────────────────
  bool isLoggedIn() {
    final session = _sessionBox.get('current');
    return session?.isLoggedIn == true;
  }

  UserHiveModel? getCurrentUser() {
    final session = _sessionBox.get('current');
    if (session == null || !session.isLoggedIn) return null;
    return _usersBox.get(session.userId);
  }

  String? getToken() {
    return _sessionBox.get('current')?.token;
  }

  Future<void> logout() async {
    final session = _sessionBox.get('current');
    if (session != null) {
      session.isLoggedIn = false;
      await session.save();
    }
  }

  // ── Settings ───────────────────────────────────────────────────────────────
  SettingsHiveModel getSettings() {
    return _settingsBox.get('app_settings') ??
        SettingsHiveModel(lastSyncAt: DateTime.now());
  }

  Future<void> updateSettings(SettingsHiveModel settings) async {
    await _settingsBox.put('app_settings', settings);
  }
}
