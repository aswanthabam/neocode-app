import 'package:digital_vault/src/core/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // ==================== AUTHENTICATION METHODS ====================

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required String passwordConfirm,
    String userType = 'individual',
    String authProvider = 'email',
  }) async {
    print('🔵 Repository: Starting registration for $email');
    try {
      final result = await _apiService.register(
        fullName: fullName,
        email: email,
        username: username,
        password: password,
        passwordConfirm: passwordConfirm,
        userType: userType,
        authProvider: authProvider,
      );
      print('🔵 Repository: Registration successful for $email');
      return result;
    } catch (e) {
      print('🔴 Repository: Registration failed for $email: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('🔵 Repository: Starting login for $email');
    try {
      final result = await _apiService.login(email: email, password: password);
      print('🔵 Repository: Login successful for $email');
      return result;
    } catch (e) {
      print('🔴 Repository: Login failed for $email: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken() async {
    try {
      return await _apiService.refreshAccessToken();
    } catch (e) {
      print('🔴 Repository: Token refresh failed: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
      print('🔵 Repository: Logout successful');
    } catch (e) {
      print('🔴 Repository: Logout failed: $e');
      rethrow;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      await _apiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirm: newPasswordConfirm,
      );
      print('🔵 Repository: Password changed successfully');
    } catch (e) {
      print('🔴 Repository: Password change failed: $e');
      rethrow;
    }
  }

  // ==================== USER PROFILE METHODS ====================

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      return await _apiService.getUserProfile();
    } catch (e) {
      print('🔴 Repository: Get user profile failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? username,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
  }) async {
    try {
      return await _apiService.updateUserProfile(
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        address: address,
      );
    } catch (e) {
      print('🔴 Repository: Update user profile failed: $e');
      rethrow;
    }
  }

  // ==================== SECURITY SETTINGS METHODS ====================

  Future<Map<String, dynamic>> getSecuritySettings() async {
    try {
      return await _apiService.getSecuritySettings();
    } catch (e) {
      print('🔴 Repository: Get security settings failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateSecuritySettings({
    String? newPin,
    bool? biometricEnabled,
    String? biometricType,
    bool? requirePinForDownloads,
    bool? requirePinForSharing,
    bool? requirePinForDeletion,
    int? autoLockTimeout,
    int? maxLoginAttempts,
    int? lockoutDuration,
    bool? twoFactorEnabled,
  }) async {
    try {
      return await _apiService.updateSecuritySettings(
        newPin: newPin,
        biometricEnabled: biometricEnabled,
        biometricType: biometricType,
        requirePinForDownloads: requirePinForDownloads,
        requirePinForSharing: requirePinForSharing,
        requirePinForDeletion: requirePinForDeletion,
        autoLockTimeout: autoLockTimeout,
        maxLoginAttempts: maxLoginAttempts,
        lockoutDuration: lockoutDuration,
        twoFactorEnabled: twoFactorEnabled,
      );
    } catch (e) {
      print('🔴 Repository: Update security settings failed: $e');
      rethrow;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      return await _apiService.verifyPin(pin);
    } catch (e) {
      print('🔴 Repository: PIN verification failed: $e');
      return false;
    }
  }

  // ==================== ORGANIZATION METHODS ====================

  Future<Map<String, dynamic>> getOrganizationProfile() async {
    try {
      return await _apiService.getOrganizationProfile();
    } catch (e) {
      print('🔴 Repository: Get organization profile failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createOrganizationProfile({
    required String name,
    required String description,
    required String organizationType,
    String? website,
    String? email,
    String? phone,
    String? address,
    bool? canIssueDocuments,
    bool? canRequestDocuments,
  }) async {
    try {
      return await _apiService.createOrganizationProfile(
        name: name,
        description: description,
        organizationType: organizationType,
        website: website,
        email: email,
        phone: phone,
        address: address,
        canIssueDocuments: canIssueDocuments,
        canRequestDocuments: canRequestDocuments,
      );
    } catch (e) {
      print('🔴 Repository: Create organization profile failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateOrganizationProfile({
    String? name,
    String? description,
    String? website,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      return await _apiService.updateOrganizationProfile(
        name: name,
        description: description,
        website: website,
        email: email,
        phone: phone,
        address: address,
      );
    } catch (e) {
      print('🔴 Repository: Update organization profile failed: $e');
      rethrow;
    }
  }

  // ==================== STATISTICS & ACTIVITY METHODS ====================

  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      return await _apiService.getUserStatistics();
    } catch (e) {
      print('🔴 Repository: Get user statistics failed: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserActivities({
    String? activityType,
    String? createdAt,
  }) async {
    try {
      return await _apiService.getUserActivities(
        activityType: activityType,
        createdAt: createdAt,
      );
    } catch (e) {
      print('🔴 Repository: Get user activities failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateNotificationPreferences({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? documentShared,
    bool? documentRequested,
    bool? requestResponded,
    bool? qrAccessed,
  }) async {
    try {
      return await _apiService.updateNotificationPreferences(
        emailNotifications: emailNotifications,
        pushNotifications: pushNotifications,
        documentShared: documentShared,
        documentRequested: documentRequested,
        requestResponded: requestResponded,
        qrAccessed: qrAccessed,
      );
    } catch (e) {
      print('🔴 Repository: Update notification preferences failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePrivacySettings({
    String? profileVisibility,
    bool? showEmail,
    bool? showPhone,
    bool? allowDocumentRequests,
    bool? allowQrSharing,
  }) async {
    try {
      return await _apiService.updatePrivacySettings(
        profileVisibility: profileVisibility,
        showEmail: showEmail,
        showPhone: showPhone,
        allowDocumentRequests: allowDocumentRequests,
        allowQrSharing: allowQrSharing,
      );
    } catch (e) {
      print('🔴 Repository: Update privacy settings failed: $e');
      rethrow;
    }
  }

  // ==================== TESTING METHODS ====================

  Future<bool> testConnection() async {
    return await _apiService.testApiConnection();
  }

  // Test basic HTTP connectivity
  Future<bool> testBasicHttp() async {
    return await _apiService.testBasicHttp();
  }

  // Legacy methods for backward compatibility
  Future<bool> sendOtp(String mobileNumber) async {
    // This is now handled by the backend during registration/login
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    // This is now handled by the backend during registration/login
    await Future.delayed(const Duration(seconds: 1));
    return otp == '123456'; // Mock OTP for backward compatibility
  }
}
