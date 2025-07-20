import 'dart:io';
import 'package:digital_vault/src/core/services/api_service.dart';

class DocumentRepository {
  final ApiService _apiService = ApiService();

  // ==================== DOCUMENT CATEGORY METHODS ====================

  Future<List<Map<String, dynamic>>> getDocumentCategories() async {
    try {
      return await _apiService.getDocumentCategories();
    } catch (e) {
      print('🔴 Repository: Get document categories failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createDocumentCategory({
    required String name,
    required String description,
    String? icon,
  }) async {
    try {
      return await _apiService.createDocumentCategory(
        name: name,
        description: description,
        icon: icon,
      );
    } catch (e) {
      print('🔴 Repository: Create document category failed: $e');
      rethrow;
    }
  }

  // ==================== DOCUMENT MANAGEMENT METHODS ====================

  Future<List<Map<String, dynamic>>> getDocuments({
    int? category,
    String? trustLevel,
    String? status,
    String? search,
    String? ordering,
  }) async {
    try {
      return await _apiService.getDocuments(
        category: category,
        trustLevel: trustLevel,
        status: status,
        search: search,
        ordering: ordering,
      );
    } catch (e) {
      print('🔴 Repository: Get documents failed: $e');
      rethrow;
    }
  }

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
      return await _apiService.uploadDocument(
        file: file,
        title: title,
        description: description,
        category: category,
        trustLevel: trustLevel,
        tags: tags,
        metadata: metadata,
      );
    } catch (e) {
      print('🔴 Repository: Upload document failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateDocument({
    required int documentId,
    String? title,
    String? description,
    int? category,
    String? trustLevel,
    List<String>? tags,
  }) async {
    try {
      return await _apiService.updateDocument(
        documentId: documentId,
        title: title,
        description: description,
        category: category,
        trustLevel: trustLevel,
        tags: tags,
      );
    } catch (e) {
      print('🔴 Repository: Update document failed: $e');
      rethrow;
    }
  }

  Future<void> deleteDocument(int documentId) async {
    try {
      await _apiService.deleteDocument(documentId);
      print('🔵 Repository: Document deleted successfully');
    } catch (e) {
      print('🔴 Repository: Delete document failed: $e');
      rethrow;
    }
  }

  Future<List<int>> downloadDocument(int documentId) async {
    try {
      return await _apiService.downloadDocument(documentId);
    } catch (e) {
      print('🔴 Repository: Download document failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDocumentStatistics() async {
    try {
      return await _apiService.getDocumentStatistics();
    } catch (e) {
      print('🔴 Repository: Get document statistics failed: $e');
      rethrow;
    }
  }

  // ==================== DOCUMENT SHARING METHODS ====================

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
