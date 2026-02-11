import 'package:flutter/foundation.dart';
import 'package:naka/features/auth/data/datasources/auth_api_service.dart';
import 'package:naka/features/auth/data/datasources/token_storage_service.dart';
import 'package:naka/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final TokenStorageService _tokenStorage;

  AuthRepositoryImpl(this._apiService, this._tokenStorage);

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await _apiService.sendOtp(phoneNumber);
  }

  @override
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    final response = await _apiService.verifyOtp(phoneNumber, otp);
    
    // Parse response based on:
    // { "success": true, "data": { "token": { "accessToken": "...", "refreshToken": "..." } } }
    if (response['success'] == true && response['data'] != null) {
      final tokenData = response['data']['token'];
      if (tokenData != null) {
        final accessToken = tokenData['accessToken'];
        final refreshToken = tokenData['refreshToken'];
        
        if (accessToken != null && refreshToken != null) {
          await _tokenStorage.saveTokens(
            accessToken: accessToken, 
            refreshToken: refreshToken
          );

          // Update SharedPreferences for EntryPoint
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
          
          // Store user info if needed
          // final user = response['data']['user'];
        }
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) {
        debugPrint("Logout: Calling API with token: $token");
        await _apiService.logout(token);
        debugPrint("Logout: API call successful");
      } else {
        debugPrint("Logout: No token found");
      }
    } catch (e) {
      debugPrint("Logout: API failed: $e");
    } finally {
      await _tokenStorage.clearTokens();
      
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('user_role');
      debugPrint("Logout: Local storage cleared");
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.hasAccessToken();
  }

  @override
  Future<String?> getToken() async {
    return await _tokenStorage.getAccessToken();
  }
}
