enum TrustLevel { issuerVerified, userUploaded }

class Document {
  final String id;
  final String name;
  final String type;
  final String issuer;
  final DateTime issueDate;
  final TrustLevel trustLevel;
  final String fileUrl; // Placeholder for the document's location

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.issuer,
    required this.issueDate,
    required this.trustLevel,
    required this.fileUrl,
  });
}
