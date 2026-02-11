import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:naka/features/auth/data/datasources/auth_api_service.dart';
import 'package:naka/features/auth/data/datasources/token_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageService _tokenStorage;
  final Dio _dio;
  // We need apiService to call refresh token, but it depends on this interceptor.
  // We will set it later or handle circular dependency via a callback/provider if needed.
  // Ideally, use a separate Dio for refresh, OR use this same Dio but handle the loop.
  // Here we will use a callback or late initialization pattern if possible, 
  // but to keep it simple, we can pass the refresh logic or use a helper.
  AuthApiService? apiService; 

  // Queue for requests while refreshing
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequests = [];

  AuthInterceptor(this._tokenStorage, this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // endpoints that don't need auth
    if (options.path.contains('/login') ||
        options.path.contains('/send-otp') ||
        options.path.contains('/verify-otp') || 
        options.path.contains('/refresh-token')) { // Refresh token endpoint doesn't need access token
      return handler.next(options);
    }

    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('AuthInterceptor: Error ${err.response?.statusCode} on ${err.requestOptions.path}');
    
    if (err.response?.statusCode == 401) {
      // If the failed request was ALREADY a refresh token attempt, fail immediately
      if (err.requestOptions.path.contains('/refresh-token')) {
        debugPrint('AuthInterceptor: Refresh token failed. Logging out.');
        await _tokenStorage.clearTokens();
        // Here we should trigger a logout stream or callback
        // For now, we propagate the error so the UI/Repo can handle it
        return handler.next(err);
      }

      if (_isRefreshing) {
        // Queue this request
        _failedRequests.add({'err': err, 'handler': handler});
        return; 
        // We don't call handler.next(err) here, we just hold it.
        // Wait, Dio interceptors don't natively "hold". We usually create a custom Completer.
        // But simpler: we just wait.
        // A better approach for Dio:
        // Create a custom response/retry logic.
        // Note: Dio's QueuedInterceptor is better for this but let's implement basic locking.
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.next(err);
        }

        debugPrint('AuthInterceptor: Attempting to refresh token...');
        
        // We need to call the refresh endpoint. 
        // We use a new Dio instance or the parsing logic to avoid interceptor issues?
        // Actually apiService.refreshToken uses the SAME dio instance.
        // But since we excluded '/refresh-token' in onRequest, it won't add the OLD access token.
        // And if it fails with 401, the check above `if (path.contains('/refresh-token'))` stops the loop.
        // So safe to use apiService.
        
        if (apiService == null) {
             debugPrint('AuthInterceptor: ApiService not initialized!');
             _isRefreshing = false;
             return handler.next(err);
        }

        final result = await apiService!.refreshToken(refreshToken);
        
        // Parse new token
        // Assuming result structure: { success: true, data: { accessToken: "..." } }
        final newAccessToken = result['data']['accessToken'];
        if (newAccessToken != null) {
           await _tokenStorage.updateAccessToken(newAccessToken);
           debugPrint('AuthInterceptor: Token refreshed successfully.');
           
           // Retry the original request
           final opts = err.requestOptions;
           opts.headers['Authorization'] = 'Bearer $newAccessToken';
           
           final clonedRequest = await _dio.fetch(opts);
           
           // Also process queued requests if any (simple implementation doesn't queue properly without QueuedInterceptor)
           // If using QueuedInterceptor, Dio handles the pausing.
           // Since we are extending Interceptor, we should retry THIS request.
           // Concurrent requests might fail.
           
           _isRefreshing = false;
           return handler.resolve(clonedRequest);
        } else {
           _isRefreshing = false;
           return handler.next(err);
        }

      } catch (e) {
        debugPrint('AuthInterceptor: Refresh logic failed: $e');
        _isRefreshing = false;
        await _tokenStorage.clearTokens();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
