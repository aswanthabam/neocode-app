import 'package:digital_vault/src/core/models/document_model.dart';

class DocumentRequest {
  final String id;
  final String requesterName;
  final String requesterId;
  final List<Document> requestedDocuments;
  final DateTime requestDate;
  final RequestStatus status;

  DocumentRequest({
    required this.id,
    required this.requesterName,
    required this.requesterId,
    required this.requestedDocuments,
    required this.requestDate,
    this.status = RequestStatus.pending,
  });
}

enum RequestStatus { pending, approved, denied }
