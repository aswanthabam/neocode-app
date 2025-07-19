import 'package:digital_vault/src/core/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<bool> sendOtp(String mobileNumber) {
    return _apiService.sendOtp(mobileNumber);
  }

  Future<bool> verifyOtp(String otp) {
    return _apiService.verifyOtp(otp);
  }

  // In a real app, you'd have methods for login, registration, logout, etc.
}
