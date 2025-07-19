import 'package:digital_vault/src/core/repositories/auth_repository.dart';
import 'package:digital_vault/src/core/repositories/document_repository.dart';
import 'package:digital_vault/src/core/repositories/request_repository.dart';
import 'package:digital_vault/src/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a singleton instance of [ApiService].
/// This service is responsible for all communication with the backend API.
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provides a singleton instance of [AuthRepository].
/// Depends on [apiServiceProvider] for authentication-related tasks.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiServiceProvider)),
);

/// Provides a singleton instance of [DocumentRepository].
/// Depends on [apiServiceProvider] to fetch document-related data.
final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepository(ref.watch(apiServiceProvider)),
);

/// Provides a singleton instance of [RequestRepository].
/// Depends on [apiServiceProvider] to fetch and manage document requests.
final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestRepository(ref.watch(apiServiceProvider)),
);

// --- Data Providers ---

/// An auto-disposing provider that asynchronously fetches the list of documents.
/// It uses [documentRepositoryProvider] to get the data.
/// The UI can watch this provider to show loading/error/data states.
final documentListProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(documentRepositoryProvider).getDocuments(),
);

/// An auto-disposing provider that asynchronously fetches the list of document requests.
/// It uses [requestRepositoryProvider] to get the data.
/// The UI can watch this provider to handle loading/error/data states for requests.
final requestListProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(requestRepositoryProvider).getRequests(),
);
