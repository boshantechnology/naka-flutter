import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naka/features/auth/data/datasources/api_interceptor.dart';
import 'package:naka/features/auth/data/datasources/auth_api_service.dart';
import 'package:naka/features/auth/data/datasources/auth_interceptor.dart';
import 'package:naka/features/auth/data/datasources/token_storage_service.dart';
import 'package:naka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naka/features/auth/domain/repositories/auth_repository.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

final dioProvider = Provider<Dio>((ref) {
  // Use http://localhost:8080 for web, but for Android emulator use 10.0.2.2
  // For physical device, use your machine's IP.
  const String baseUrl = 'http://localhost:8080/api/v1/auth'; 

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  final storage = ref.read(tokenStorageServiceProvider);
  final authInterceptor = AuthInterceptor(storage, dio);
  
  // Add interceptors
  dio.interceptors.add(ApiInterceptor()); // Logging
  dio.interceptors.add(authInterceptor); // Auth Logic

  return dio;
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioProvider);
  final service = AuthApiService(dio);
  
  // Resolve circular dependency: AuthInterceptor needs ApiService for refresh
  try {
    final interceptor = dio.interceptors.whereType<AuthInterceptor>().first;
    interceptor.apiService = service;
  } catch (e) {
    // Should not happen if dioProvider is correct
  }
  
  return service;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(authApiServiceProvider);
  final storage = ref.watch(tokenStorageServiceProvider);
  return AuthRepositoryImpl(apiService, storage);
});
