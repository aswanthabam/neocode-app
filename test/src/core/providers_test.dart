import 'package:digital_vault/src/core/models/document_model.dart';
import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:digital_vault/src/core/providers/providers.dart';
import 'package:digital_vault/src/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Create a mock ApiService class
class MockApiService extends Mock implements ApiService {}

void main() {
  group('Providers Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    test('documentListProvider returns a list of documents on success', () async {
      // Arrange: Define the mock data and behavior
      final mockDocuments = [
        Document(
          id: '1',
          name: 'Test Doc 1',
          type: 'Test',
          issuer: 'Tester',
          issueDate: DateTime.now(),
          trustLevel: TrustLevel.issuerVerified,
          fileUrl: '',
        ),
      ];

      when(() => mockApiService.getDocuments()).thenAnswer((_) async => mockDocuments);

      // Act: Create a ProviderContainer to test the provider
      final container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );

      // Assert: Check that the provider starts in a loading state
      expect(
        container.read(documentListProvider),
        const AsyncValue<List<Document>>.loading(),
      );

      // Wait for the future to complete
      await container.read(documentListProvider.future);

      // Assert: Check that the provider's state is now the mock data
      expect(
        container.read(documentListProvider).value,
        mockDocuments,
      );
    });

    test('documentListProvider returns an error when ApiService throws', () async {
      // Arrange: Define the mock error behavior
      final exception = Exception('Failed to fetch documents');
      when(() => mockApiService.getDocuments()).thenThrow(exception);

      // Act: Create a ProviderContainer
      final container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );

      // Wait for the future to complete
      await container.read(documentListProvider.future).catchError((_) => {});

      // Assert: Check that the provider's state is an error
      expect(
        container.read(documentListProvider),
        isA<AsyncError>()..having((e) => e.error, 'error', exception),
      );
    });

    test('requestListProvider returns a list of requests on success', () async {
      // Arrange
      final mockRequests = [
        DocumentRequest(
          id: 'req1',
          requesterName: 'Test Requester',
          requesterId: 'test@requester.com',
          requestDate: DateTime.now(),
          requestedDocuments: [],
        ),
      ];
      when(() => mockApiService.getRequests()).thenAnswer((_) async => mockRequests);

      // Act
      final container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );

      // Assert
      expect(
        container.read(requestListProvider),
        const AsyncValue<List<DocumentRequest>>.loading(),
      );

      await container.read(requestListProvider.future);

      expect(
        container.read(requestListProvider).value,
        mockRequests,
      );
    });

    test('requestListProvider returns an error when ApiService throws', () async {
      // Arrange
      final exception = Exception('Failed to fetch requests');
      when(() => mockApiService.getRequests()).thenThrow(exception);

      // Act
      final container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );

      // Wait for the future to complete
      await container.read(requestListProvider.future).catchError((_) => {});

      // Assert
      expect(
        container.read(requestListProvider),
        isA<AsyncError>()..having((e) => e.error, 'error', exception),
      );
    });
  });
}
