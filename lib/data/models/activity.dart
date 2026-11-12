enum ActivityType { call, meeting, task }

class ActivityItem {
  final String id;
  final String title;
  final ActivityType type;
  final DateTime scheduledAt;
  final String entityName; // Contact or Deal name
  final bool isCompleted;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.type,
    required this.scheduledAt,
    required this.entityName,
    this.isCompleted = false,
  });
}
