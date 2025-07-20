import 'dart:convert';
import 'dart:io';
import 'package:digital_vault/src/core/models/document_model.dart';
import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:digital_vault/src/core/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://6d271e879a3e.ngrok-free.app/api/v1';
  static String? _accessToken;
  static String? _refreshToken;

  // Set access token after login
  static void setAccessToken(String token) {
    _accessToken = token;
  }

  // Set refresh token
  static void setRefreshToken(String token) {
    _refreshToken = token;
  }

  // Get access token
  static String? get accessToken => _accessToken;

  // Get refresh token
  static String? get refreshToken => _refreshToken;

  // Clear tokens on logout
  static void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  // Helper method to get headers
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  // Test API connectivity
  Future<bool> testApiConnection() async {
    try {
      print('🔵 API: Testing connection to $baseUrl');
      final response = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('🔴 API: Connection test timeout');
              throw Exception('Connection timeout');
            },
          );
      print(
        '🔵 API: Connection test successful - Status: ${response.statusCode}',
      );
      return true;
    } catch (e) {
      print('🔴 API: Connection test failed: $e');
      return false;
    }
  }

  // Test basic HTTP connectivity
  Future<bool> testBasicHttp() async {
    try {
      print('🔵 API: Testing basic HTTP to google.com');
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('🔴 API: Basic HTTP test timeout');
              throw Exception('Basic HTTP timeout');
            },
          );
      print(
        '🔵 API: Basic HTTP test successful - Status: ${response.statusCode}',
      );
      return true;
    } catch (e) {
      print('🔴 API: Basic HTTP test failed: $e');
      return false;
    }
  }

  // ==================== AUTHENTICATION APIs ====================

  // 1. User Registration
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required String passwordConfirm,
    String userType = 'individual',
    String authProvider = 'email',
  }) async {
    print('🔵 API: Starting registration for $email');
    try {
      final url = '$baseUrl/auth/register/';
      final body = {
        'full_name': fullName,
        'email': email,
        'username': username,
        'password': password,
        'password_confirm': passwordConfirm,
        'user_type': userType,
        'auth_provider': authProvider,
      };

      print('🔵 API: URL: $url');
      print('🔵 API: Body: ${jsonEncode(body)}');
      print('🔵 API: Headers: $_headers');
      print('🔵 API: Making HTTP request...');

      final response = await http
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print('🔴 API: Request timeout for registration');
              throw Exception('Request timeout');
            },
          );

      print('🔵 API: HTTP request completed');
      print('🔵 API: Response status: ${response.statusCode}');
      print('🔵 API: Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Store tokens
        if (data['tokens'] != null) {
          setAccessToken(data['tokens']['access']);
          setRefreshToken(data['tokens']['refresh']);
          print('🔵 API: Tokens stored');
        }
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('🔴 API: Registration error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Network connection failed. Please check your internet connection.',
        );
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      } else {
        throw Exception('Network error: $e');
      }
    }
  }

  // 2. User Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('🔵 API: Starting login for $email');
    try {
      final url = '$baseUrl/auth/login/';
      final body = {'email': email, 'password': password};

      print('🔵 API: URL: $url');
      print('🔵 API: Body: ${jsonEncode(body)}');
      print('🔵 API: Headers: $_headers');
      print('🔵 API: Making HTTP request...');

      final response = await http
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print('🔴 API: Request timeout for login');
              throw Exception('Request timeout');
            },
          );

      print('🔵 API: HTTP request completed');
      print('🔵 API: Response status: ${response.statusCode}');
      print('🔵 API: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Store tokens
        if (data['tokens'] != null) {
          setAccessToken(data['tokens']['access']);
          setRefreshToken(data['tokens']['refresh']);
          print('🔵 API: Tokens stored');
        }
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('🔴 API: Login error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Network connection failed. Please check your internet connection.',
        );
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      } else {
        throw Exception('Network error: $e');
      }
    }
  }

  // 3. Token Refresh
  Future<Map<String, dynamic>> refreshAccessToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/token/refresh/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': _refreshToken}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setAccessToken(data['access']);
        if (data['refresh'] != null) {
          setRefreshToken(data['refresh']);
        }
        return data;
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh error: $e');
    }
  }

  // 4. Logout
  Future<void> logout() async {
    if (_refreshToken == null) {
      clearTokens();
      return;
    }

    try {
      await http
          .post(
            Uri.parse('$baseUrl/auth/logout/'),
            headers: _headers,
            body: jsonEncode({'refresh': _refreshToken}),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      print('🔴 API: Logout error: $e');
    } finally {
      clearTokens();
    }
  }

  // 5. Password Change
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/password/change/'),
            headers: _headers,
            body: jsonEncode({
              'old_password': oldPassword,
              'new_password': newPassword,
              'new_password_confirm': newPasswordConfirm,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Password change failed');
      }
    } catch (e) {
      throw Exception('Password change error: $e');
    }
  }

  // ==================== USER PROFILE APIs ====================

  // 6. Get User Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/auth/profile/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Get profile error: $e');
    }
  }

  // 7. Update User Profile
  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? username,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (username != null) body['username'] = username;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
      if (address != null) body['address'] = address;

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/profile/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Update profile error: $e');
    }
  }

  // ==================== SECURITY SETTINGS APIs ====================

  // 8. Get Security Settings
  Future<Map<String, dynamic>> getSecuritySettings() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/auth/security/settings/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get security settings');
      }
    } catch (e) {
      throw Exception('Get security settings error: $e');
    }
  }

  // 9. Update Security Settings
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
      final body = <String, dynamic>{};
      if (newPin != null) body['new_pin'] = newPin;
      if (biometricEnabled != null)
        body['biometric_enabled'] = biometricEnabled;
      if (biometricType != null) body['biometric_type'] = biometricType;
      if (requirePinForDownloads != null)
        body['require_pin_for_downloads'] = requirePinForDownloads;
      if (requirePinForSharing != null)
        body['require_pin_for_sharing'] = requirePinForSharing;
      if (requirePinForDeletion != null)
        body['require_pin_for_deletion'] = requirePinForDeletion;
      if (autoLockTimeout != null) body['auto_lock_timeout'] = autoLockTimeout;
      if (maxLoginAttempts != null)
        body['max_login_attempts'] = maxLoginAttempts;
      if (lockoutDuration != null) body['lockout_duration'] = lockoutDuration;
      if (twoFactorEnabled != null)
        body['two_factor_enabled'] = twoFactorEnabled;

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/security/settings/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update security settings');
      }
    } catch (e) {
      throw Exception('Update security settings error: $e');
    }
  }

  // 10. Verify PIN
  Future<bool> verifyPin(String pin) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/security/verify-pin/'),
            headers: _headers,
            body: jsonEncode({'pin': pin}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['verified'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ==================== ORGANIZATION APIs ====================

  // 11. Get Organization Profile
  Future<Map<String, dynamic>> getOrganizationProfile() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/auth/organization/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get organization profile');
      }
    } catch (e) {
      throw Exception('Get organization error: $e');
    }
  }

  // 12. Create Organization Profile
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
      final body = {
        'name': name,
        'description': description,
        'organization_type': organizationType,
        if (website != null) 'website': website,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (canIssueDocuments != null) 'can_issue_documents': canIssueDocuments,
        if (canRequestDocuments != null)
          'can_request_documents': canRequestDocuments,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/organization/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create organization profile');
      }
    } catch (e) {
      throw Exception('Create organization error: $e');
    }
  }

  // 13. Update Organization Profile
  Future<Map<String, dynamic>> updateOrganizationProfile({
    String? name,
    String? description,
    String? website,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (website != null) body['website'] = website;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (address != null) body['address'] = address;

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/organization/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update organization profile');
      }
    } catch (e) {
      throw Exception('Update organization error: $e');
    }
  }

  // ==================== STATISTICS & ACTIVITY APIs ====================

  // 14. Get User Statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/auth/stats/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user statistics');
      }
    } catch (e) {
      throw Exception('Get statistics error: $e');
    }
  }

  // 15. Get User Activities
  Future<List<Map<String, dynamic>>> getUserActivities({
    String? activityType,
    String? createdAt,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (activityType != null) queryParams['activity_type'] = activityType;
      if (createdAt != null) queryParams['created_at'] = createdAt;

      final uri = Uri.parse(
        '$baseUrl/auth/activities/',
      ).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get user activities');
      }
    } catch (e) {
      throw Exception('Get activities error: $e');
    }
  }

  // 16. Update Notification Preferences
  Future<Map<String, dynamic>> updateNotificationPreferences({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? documentShared,
    bool? documentRequested,
    bool? requestResponded,
    bool? qrAccessed,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (emailNotifications != null)
        body['email_notifications'] = emailNotifications;
      if (pushNotifications != null)
        body['push_notifications'] = pushNotifications;
      if (documentShared != null) body['document_shared'] = documentShared;
      if (documentRequested != null)
        body['document_requested'] = documentRequested;
      if (requestResponded != null)
        body['request_responded'] = requestResponded;
      if (qrAccessed != null) body['qr_accessed'] = qrAccessed;

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/notifications/preferences/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update notification preferences');
      }
    } catch (e) {
      throw Exception('Update notification preferences error: $e');
    }
  }

  // 17. Update Privacy Settings
  Future<Map<String, dynamic>> updatePrivacySettings({
    String? profileVisibility,
    bool? showEmail,
    bool? showPhone,
    bool? allowDocumentRequests,
    bool? allowQrSharing,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (profileVisibility != null)
        body['profile_visibility'] = profileVisibility;
      if (showEmail != null) body['show_email'] = showEmail;
      if (showPhone != null) body['show_phone'] = showPhone;
      if (allowDocumentRequests != null)
        body['allow_document_requests'] = allowDocumentRequests;
      if (allowQrSharing != null) body['allow_qr_sharing'] = allowQrSharing;

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/privacy/settings/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update privacy settings');
      }
    } catch (e) {
      throw Exception('Update privacy settings error: $e');
    }
  }

  // ==================== DOCUMENT MANAGEMENT APIs ====================

  // 18. List Document Categories
  Future<List<Map<String, dynamic>>> getDocumentCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/documents/categories/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get document categories');
      }
    } catch (e) {
      throw Exception('Get categories error: $e');
    }
  }

  // 19. Create Document Category
  Future<Map<String, dynamic>> createDocumentCategory({
    required String name,
    required String description,
    String? icon,
  }) async {
    try {
      final body = {
        'name': name,
        'description': description,
        if (icon != null) 'icon': icon,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/documents/categories/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create document category');
      }
    } catch (e) {
      throw Exception('Create category error: $e');
    }
  }

  // 20. List Documents
  Future<List<Map<String, dynamic>>> getDocuments({
    int? category,
    String? trustLevel,
    String? status,
    String? search,
    String? ordering,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category.toString();
      if (trustLevel != null) queryParams['trust_level'] = trustLevel;
      if (status != null) queryParams['status'] = status;
      if (search != null) queryParams['search'] = search;
      if (ordering != null) queryParams['ordering'] = ordering;

      final uri = Uri.parse(
        '$baseUrl/documents/',
      ).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get documents');
      }
    } catch (e) {
      throw Exception('Get documents error: $e');
    }
  }

  // 21. Upload Document
  Future<Map<String, dynamic>> uploadDocument({
    required File file,
    required String title,
    String? description,
    required int category,
    String? trustLevel,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/documents/'),
      );

      request.headers['Authorization'] = 'Bearer $_accessToken';
      request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      request.fields['category'] = category.toString();
      if (trustLevel != null) request.fields['trust_level'] = trustLevel;
      if (tags != null) request.fields['tags'] = tags.join(',');
      if (metadata != null) request.fields['metadata'] = jsonEncode(metadata);

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to upload document');
      }
    } catch (e) {
      throw Exception('Upload document error: $e');
    }
  }

  // 22. Update Document
  Future<Map<String, dynamic>> updateDocument({
    required int documentId,
    String? title,
    String? description,
    int? category,
    String? trustLevel,
    List<String>? tags,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (category != null) body['category'] = category;
      if (trustLevel != null) body['trust_level'] = trustLevel;
      if (tags != null) body['tags'] = tags;

      final response = await http
          .put(
            Uri.parse('$baseUrl/documents/$documentId/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update document');
      }
    } catch (e) {
      throw Exception('Update document error: $e');
    }
  }

  // 23. Delete Document
  Future<void> deleteDocument(int documentId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/documents/$documentId/'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete document');
      }
    } catch (e) {
      throw Exception('Delete document error: $e');
    }
  }

  // 24. Download Document
  Future<List<int>> downloadDocument(int documentId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/documents/$documentId/download/'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to download document');
      }
    } catch (e) {
      throw Exception('Download document error: $e');
    }
  }

  // 25. Document Statistics
  Future<Map<String, dynamic>> getDocumentStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/documents/stats/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get document statistics');
      }
    } catch (e) {
      throw Exception('Get document statistics error: $e');
    }
  }

  // ==================== DOCUMENT SHARING APIs ====================

  // 26. List Document Shares
  Future<List<Map<String, dynamic>>> getDocumentShares({
    String? status,
    String? permission,
    String? createdAt,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (permission != null) queryParams['permission'] = permission;
      if (createdAt != null) queryParams['created_at'] = createdAt;

      final uri = Uri.parse(
        '$baseUrl/sharing/requests/',
      ).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get document shares');
      }
    } catch (e) {
      throw Exception('Get document shares error: $e');
    }
  }

  // 27. Share Document
  Future<Map<String, dynamic>> shareDocument({
    required int document,
    required String userEmail,
    required String permission,
    String? expiresAt,
    String? message,
  }) async {
    try {
      final body = {
        'document': document,
        'user_email': userEmail,
        'permission': permission,
        if (expiresAt != null) 'expires_at': expiresAt,
        if (message != null) 'message': message,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/requests/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to share document');
      }
    } catch (e) {
      throw Exception('Share document error: $e');
    }
  }

  // 28. Accept/Decline Share
  Future<void> respondToShare({
    required int shareId,
    required bool accept,
    String? reason,
  }) async {
    try {
      final endpoint = accept ? 'accept' : 'decline';
      final body = <String, dynamic>{};
      if (reason != null) body['reason'] = reason;

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/requests/$shareId/$endpoint/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to ${accept ? 'accept' : 'decline'} share');
      }
    } catch (e) {
      throw Exception('Respond to share error: $e');
    }
  }

  // ==================== QR CODE SHARING APIs ====================

  // 29. List QR Code Shares
  Future<List<Map<String, dynamic>>> getQrCodeShares({
    String? status,
    String? permission,
    String? createdAt,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (permission != null) queryParams['permission'] = permission;
      if (createdAt != null) queryParams['created_at'] = createdAt;

      final uri = Uri.parse(
        '$baseUrl/sharing/qr-shares/',
      ).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get QR code shares');
      }
    } catch (e) {
      throw Exception('Get QR code shares error: $e');
    }
  }

  // 30. Create QR Code Share
  Future<Map<String, dynamic>> createQrCodeShare({
    required int document,
    required String title,
    String? description,
    required String permission,
    required String expiresAt,
    int? maxViews,
  }) async {
    try {
      final body = {
        'document': document,
        'title': title,
        if (description != null) 'description': description,
        'permission': permission,
        'expires_at': expiresAt,
        if (maxViews != null) 'max_views': maxViews,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/qr-shares/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create QR code share');
      }
    } catch (e) {
      throw Exception('Create QR code share error: $e');
    }
  }

  // 31. Revoke QR Code
  Future<void> revokeQrCode(int qrCodeId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/qr-shares/$qrCodeId/revoke/'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to revoke QR code');
      }
    } catch (e) {
      throw Exception('Revoke QR code error: $e');
    }
  }

  // 32. Bulk Create QR Codes
  Future<Map<String, dynamic>> bulkCreateQrCodes({
    required List<int> documentIds,
    required String title,
    String? description,
    required String permission,
    required String expiresAt,
    int? maxViews,
  }) async {
    try {
      final body = {
        'document_ids': documentIds,
        'title': title,
        if (description != null) 'description': description,
        'permission': permission,
        'expires_at': expiresAt,
        if (maxViews != null) 'max_views': maxViews,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/qr-shares/bulk_create/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to bulk create QR codes');
      }
    } catch (e) {
      throw Exception('Bulk create QR codes error: $e');
    }
  }

  // 33. Access Document via QR Code
  Future<Map<String, dynamic>> accessDocumentViaQrCode(
    String sessionToken,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/access/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'session_token': sessionToken}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to access document via QR code');
      }
    } catch (e) {
      throw Exception('Access document via QR code error: $e');
    }
  }

  // ==================== DOCUMENT REQUESTS APIs ====================

  // 34. List Document Requests
  Future<List<Map<String, dynamic>>> getDocumentRequests({
    String? status,
    int? category,
    String? createdAt,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category.toString();
      if (createdAt != null) queryParams['created_at'] = createdAt;

      final uri = Uri.parse(
        '$baseUrl/sharing/requests/',
      ).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get document requests');
      }
    } catch (e) {
      throw Exception('Get document requests error: $e');
    }
  }

  // 35. Create Document Request
  Future<Map<String, dynamic>> createDocumentRequest({
    required String title,
    required String description,
    required int category,
    required String issuerEmail,
    String? dueDate,
    String? reason,
  }) async {
    try {
      final body = {
        'title': title,
        'description': description,
        'category': category,
        'issuer_email': issuerEmail,
        if (dueDate != null) 'due_date': dueDate,
        if (reason != null) 'reason': reason,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/requests/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create document request');
      }
    } catch (e) {
      throw Exception('Create document request error: $e');
    }
  }

  // 36. Approve/Decline Document Request
  Future<void> respondToDocumentRequest({
    required int requestId,
    required bool approve,
    String? reason,
  }) async {
    try {
      final endpoint = approve ? 'approve' : 'decline';
      final body = <String, dynamic>{};
      if (reason != null) body['reason'] = reason;

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/requests/$requestId/$endpoint/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to ${approve ? 'approve' : 'decline'} document request',
        );
      }
    } catch (e) {
      throw Exception('Respond to document request error: $e');
    }
  }

  // ==================== SHARING STATISTICS APIs ====================

  // 37. Get Sharing Statistics
  Future<Map<String, dynamic>> getSharingStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sharing/stats/'), headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get sharing statistics');
      }
    } catch (e) {
      throw Exception('Get sharing statistics error: $e');
    }
  }

  // 38. Bulk Share Documents
  Future<Map<String, dynamic>> bulkShareDocuments({
    required List<int> documentIds,
    required List<String> userEmails,
    required String permission,
    String? expiresAt,
    String? message,
  }) async {
    try {
      final body = {
        'document_ids': documentIds,
        'user_emails': userEmails,
        'permission': permission,
        if (expiresAt != null) 'expires_at': expiresAt,
        if (message != null) 'message': message,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/bulk/'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to bulk share documents');
      }
    } catch (e) {
      throw Exception('Bulk share documents error: $e');
    }
  }

  // ==================== NOTIFICATION APIs ====================

  // 39. List Share Notifications
  Future<List<Map<String, dynamic>>> getShareNotifications({
    String? notificationType,
    bool? isRead,
    String? createdAt,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (notificationType != null)
        queryParams['notification_type'] = notificationType;
      if (isRead != null) queryParams['is_read'] = isRead.toString();
      if (createdAt != null) queryParams['created_at'] = createdAt;

      final uri = Uri.parse(
        '$baseUrl/sharing/notifications/',
      ).replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get share notifications');
      }
    } catch (e) {
      throw Exception('Get share notifications error: $e');
    }
  }

  // 40. Mark Notification as Read
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
              '$baseUrl/sharing/notifications/$notificationId/mark_read/',
            ),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Mark notification as read error: $e');
    }
  }

  // 41. Mark All Notifications as Read
  Future<void> markAllNotificationsAsRead() async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/sharing/notifications/mark_all_read/'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e) {
      throw Exception('Mark all notifications as read error: $e');
    }
  }
}
