import 'package:digital_vault/src/core/models/document_model.dart';
import 'package:digital_vault/src/core/services/api_service.dart';

class DocumentRepository {
  final ApiService _apiService;

  DocumentRepository(this._apiService);

  Future<List<Document>> getDocuments() {
    return _apiService.getDocuments();
  }

  // You can add other document-related methods here, e.g.:
  // Future<void> addDocument(Document doc) { ... }
  // Future<void> deleteDocument(String id) { ... }
}
