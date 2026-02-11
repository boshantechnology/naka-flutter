import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:naka/features/auth/data/datasources/api_interceptor.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _dio.post('/send-otp', data: {'phoneNumber': phoneNumber});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _dio.post('/verify-otp', data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      });
      return response.data; // Assuming response contains token/user
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post(
        '/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      debugPrint('AuthApiService: Logout API called successfully');
    } on DioException catch (e) {
      // Even if logout fails on server, we will clear local token in Repository
      // But we can throw to let interceptors or UI know if needed
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/refresh-token', data: {
        'refreshToken': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    String errorDescription = "";
    if (error.response != null) {
      // Server error
      errorDescription = error.response?.data['message'] ?? 'Server error';
    } else {
      // Network error
      errorDescription = 'Network error. Please check your connection.';
    }
    return errorDescription;
  }
}
