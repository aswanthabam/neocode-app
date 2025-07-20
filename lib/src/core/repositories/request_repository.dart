import 'package:digital_vault/src/core/services/api_service.dart';

class RequestRepository {
  final ApiService _apiService = ApiService();

  // ==================== DOCUMENT REQUESTS METHODS ====================

  Future<List<Map<String, dynamic>>> getDocumentRequests({
    String? status,
    int? category,
    String? createdAt,
  }) async {
    try {
      return await _apiService.getDocumentRequests(
        status: status,
        category: category,
        createdAt: createdAt,
      );
    } catch (e) {
      print('🔴 Repository: Get document requests failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createDocumentRequest({
    required String title,
    required String description,
    required int category,
    required String issuerEmail,
    String? dueDate,
    String? reason,
  }) async {
    try {
      return await _apiService.createDocumentRequest(
        title: title,
        description: description,
        category: category,
        issuerEmail: issuerEmail,
        dueDate: dueDate,
        reason: reason,
      );
    } catch (e) {
      print('🔴 Repository: Create document request failed: $e');
      rethrow;
    }
  }

  Future<void> respondToDocumentRequest({
    required int requestId,
    required bool approve,
    String? reason,
  }) async {
    try {
      await _apiService.respondToDocumentRequest(
        requestId: requestId,
        approve: approve,
        reason: reason,
      );
      print('🔵 Repository: Document request response sent successfully');
    } catch (e) {
      print('🔴 Repository: Respond to document request failed: $e');
      rethrow;
    }
  }

  // ==================== DOCUMENT SHARES METHODS ====================

  Future<List<Map<String, dynamic>>> getDocumentShares({
    String? status,
    String? permission,
    String? createdAt,
  }) async {
    try {
      return await _apiService.getDocumentShares(
        status: status,
        permission: permission,
        createdAt: createdAt,
      );
    } catch (e) {
      print('🔴 Repository: Get document shares failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> shareDocument({
    required int document,
    required String userEmail,
    required String permission,
    String? expiresAt,
    String? message,
  }) async {
    try {
      return await _apiService.shareDocument(
        document: document,
        userEmail: userEmail,
        permission: permission,
        expiresAt: expiresAt,
        message: message,
      );
    } catch (e) {
      print('🔴 Repository: Share document failed: $e');
      rethrow;
    }
  }

  Future<void> respondToShare({
    required int shareId,
    required bool accept,
    String? reason,
  }) async {
    try {
      await _apiService.respondToShare(
        shareId: shareId,
        accept: accept,
        reason: reason,
      );
      print('🔵 Repository: Share response sent successfully');
    } catch (e) {
      print('🔴 Repository: Respond to share failed: $e');
      rethrow;
    }
  }

  // ==================== QR CODE SHARING METHODS ====================

  Future<List<Map<String, dynamic>>> getQrCodeShares({
    String? status,
    String? permission,
    String? createdAt,
  }) async {
    try {
      return await _apiService.getQrCodeShares(
        status: status,
        permission: permission,
        createdAt: createdAt,
      );
    } catch (e) {
      print('🔴 Repository: Get QR code shares failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createQrCodeShare({
    required int document,
    required String title,
    String? description,
    required String permission,
    required String expiresAt,
    int? maxViews,
  }) async {
    try {
      return await _apiService.createQrCodeShare(
        document: document,
        title: title,
        description: description,
        permission: permission,
        expiresAt: expiresAt,
        maxViews: maxViews,
      );
    } catch (e) {
      print('🔴 Repository: Create QR code share failed: $e');
      rethrow;
    }
  }

  Future<void> revokeQrCode(int qrCodeId) async {
    try {
      await _apiService.revokeQrCode(qrCodeId);
      print('🔵 Repository: QR code revoked successfully');
    } catch (e) {
      print('🔴 Repository: Revoke QR code failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> bulkCreateQrCodes({
    required List<int> documentIds,
    required String title,
    String? description,
    required String permission,
    required String expiresAt,
    int? maxViews,
  }) async {
    try {
      return await _apiService.bulkCreateQrCodes(
        documentIds: documentIds,
        title: title,
        description: description,
        permission: permission,
        expiresAt: expiresAt,
        maxViews: maxViews,
      );
    } catch (e) {
      print('🔴 Repository: Bulk create QR codes failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> accessDocumentViaQrCode(
    String sessionToken,
  ) async {
    try {
      return await _apiService.accessDocumentViaQrCode(sessionToken);
    } catch (e) {
      print('🔴 Repository: Access document via QR code failed: $e');
      rethrow;
    }
  }

  // ==================== SHARING STATISTICS METHODS ====================

  Future<Map<String, dynamic>> getSharingStatistics() async {
    try {
      return await _apiService.getSharingStatistics();
    } catch (e) {
      print('🔴 Repository: Get sharing statistics failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> bulkShareDocuments({
    required List<int> documentIds,
    required List<String> userEmails,
    required String permission,
    String? expiresAt,
    String? message,
  }) async {
    try {
      return await _apiService.bulkShareDocuments(
        documentIds: documentIds,
        userEmails: userEmails,
        permission: permission,
        expiresAt: expiresAt,
        message: message,
      );
    } catch (e) {
      print('🔴 Repository: Bulk share documents failed: $e');
      rethrow;
    }
  }

  // ==================== NOTIFICATION METHODS ====================

  Future<List<Map<String, dynamic>>> getShareNotifications({
    String? notificationType,
    bool? isRead,
    String? createdAt,
  }) async {
    try {
      return await _apiService.getShareNotifications(
        notificationType: notificationType,
        isRead: isRead,
        createdAt: createdAt,
      );
    } catch (e) {
      print('🔴 Repository: Get share notifications failed: $e');
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      await _apiService.markNotificationAsRead(notificationId);
      print('🔵 Repository: Notification marked as read');
    } catch (e) {
      print('🔴 Repository: Mark notification as read failed: $e');
      rethrow;
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();
      print('🔵 Repository: All notifications marked as read');
    } catch (e) {
      print('🔴 Repository: Mark all notifications as read failed: $e');
      rethrow;
    }
  }
}
