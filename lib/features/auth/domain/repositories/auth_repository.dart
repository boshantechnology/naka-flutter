abstract class AuthRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<void> verifyOtp(String phoneNumber, String otp);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}
