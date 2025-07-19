enum ActivityType { documentViewed, documentShared, requestReceived, requestApproved, requestDenied }

class Activity {
  final String id;
  final ActivityType type;
  final String description;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
  });
}
