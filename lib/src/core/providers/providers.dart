import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_vault/src/core/repositories/auth_repository.dart';
import 'package:digital_vault/src/core/repositories/document_repository.dart';
import 'package:digital_vault/src/core/repositories/request_repository.dart';

// ==================== REPOSITORY PROVIDERS ====================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepository();
});

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository();
});

// ==================== AUTH STATE PROVIDERS ====================

final isLoggedInProvider = StateProvider<bool>((ref) {
  return false;
});

final currentUserProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

final userProfileProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

final securitySettingsProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// ==================== DOCUMENT STATE PROVIDERS ====================

final documentsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

final documentCategoriesProvider = StateProvider<List<Map<String, dynamic>>>((
  ref,
) {
  return [];
});

final documentStatisticsProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// ==================== REQUEST STATE PROVIDERS ====================

final documentRequestsProvider = StateProvider<List<Map<String, dynamic>>>((
  ref,
) {
  return [];
});

final documentSharesProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

final qrCodeSharesProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

final sharingStatisticsProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// ==================== NOTIFICATION STATE PROVIDERS ====================

final notificationsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

final unreadNotificationsCountProvider = StateProvider<int>((ref) {
  return 0;
});

// ==================== LOADING STATE PROVIDERS ====================

final isLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final authLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final documentsLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final requestsLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

// ==================== ERROR STATE PROVIDERS ====================

final errorMessageProvider = StateProvider<String?>((ref) {
  return null;
});

final authErrorProvider = StateProvider<String?>((ref) {
  return null;
});

final documentsErrorProvider = StateProvider<String?>((ref) {
  return null;
});

final requestsErrorProvider = StateProvider<String?>((ref) {
  return null;
});

// ==================== FILTER STATE PROVIDERS ====================

final selectedCategoryProvider = StateProvider<int?>((ref) {
  return null;
});

final selectedTrustLevelProvider = StateProvider<String?>((ref) {
  return null;
});

final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

final sortOrderProvider = StateProvider<String>((ref) {
  return 'created_at';
});

// ==================== UI STATE PROVIDERS ====================

final selectedTabProvider = StateProvider<int>((ref) {
  return 0;
});

final showAddDocumentModalProvider = StateProvider<bool>((ref) {
  return false;
});

final showShareModalProvider = StateProvider<bool>((ref) {
  return false;
});

final selectedDocumentProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// ==================== THEME STATE PROVIDERS ====================

final isDarkModeProvider = StateProvider<bool>((ref) {
  return false;
});

final primaryColorProvider = StateProvider<int>((ref) {
  return 0xFF2196F3; // Blue
});

// ==================== BIOMETRIC STATE PROVIDERS ====================

final biometricEnabledProvider = StateProvider<bool>((ref) {
  return false;
});

final biometricTypeProvider = StateProvider<String>((ref) {
  return 'fingerprint';
});

// ==================== PIN STATE PROVIDERS ====================

final pinSetProvider = StateProvider<bool>((ref) {
  return false;
});

final pinLengthProvider = StateProvider<int>((ref) {
  return 4;
});

// ==================== ORGANIZATION STATE PROVIDERS ====================

final organizationProfileProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

final userStatisticsProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

final userActivitiesProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

// ==================== NOTIFICATION PREFERENCES PROVIDERS ====================

final notificationPreferencesProvider = StateProvider<Map<String, dynamic>?>((
  ref,
) {
  return null;
});

final privacySettingsProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});
