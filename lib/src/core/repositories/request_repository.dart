import 'package:digital_vault/src/core/models/request_model.dart';
import 'package:digital_vault/src/core/services/api_service.dart';

class RequestRepository {
  final ApiService _apiService;

  RequestRepository(this._apiService);

  Future<List<DocumentRequest>> getRequests() {
    return _apiService.getRequests();
  }

  // You can add other request-related methods here, e.g.:
  // Future<void> approveRequest(String id) { ... }
  // Future<void> denyRequest(String id) { ... }
}
