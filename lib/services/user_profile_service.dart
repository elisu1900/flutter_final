import 'dart:convert';
import 'package:flutter_final_app/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';





class UserProfileService {
  static const String _key = 'user_profile_v1';

  // Perfil en memoria (caché ligera)
  static UserProfile? _cache;

  static Future<UserProfile?> getProfile() async {
    if (_cache != null) return _cache;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    _cache = UserProfile.fromJson(jsonDecode(raw));
    return _cache;
  }

  static Future<void> saveProfile(UserProfile p) async {
    _cache = p;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(p.toJson()));
  }

  static Future<void> clearProfile() async {
    _cache = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static void clearCache() => _cache = null;
}



