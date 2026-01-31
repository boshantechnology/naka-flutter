// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyPhoneNumber = 'user_phone';

  Future<void> savePhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phone);
  }

  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  Future<void> loginSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
