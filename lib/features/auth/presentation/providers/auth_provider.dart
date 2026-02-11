import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naka/features/auth/domain/repositories/auth_repository.dart';
import 'package:naka/features/auth/presentation/providers/auth_di_providers.dart';

// Auth State States
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthCodeSent extends AuthState {
  final String phoneNumber;
  AuthCodeSent(this.phoneNumber);
}
class AuthAuthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthInitial());

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      state = AuthAuthenticated();
    } else {
      state = AuthInitial();
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = AuthLoading();
    try {
      await _repository.sendOtp(phoneNumber);
      state = AuthCodeSent(phoneNumber);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = AuthLoading();
    try {
      await _repository.verifyOtp(phoneNumber, otp);
      state = AuthAuthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    await _repository.logout();
    state = AuthInitial();
  }
  
  void reset() {
    state = AuthInitial();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
