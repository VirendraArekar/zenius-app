import '../models/activity.dart';
import '../../core/network/api_client.dart';

class ActivityRepository {
  final ApiClient apiClient;

  ActivityRepository({required this.apiClient});

  final List<ActivityItem> _activities = [
    ActivityItem(
      id: 'act-1',
      title: 'Product Demo & Architecture Walkthrough',
      type: ActivityType.meeting,
      scheduledAt: DateTime.now().add(const Duration(hours: 1)),
      entityName: 'Apex Technologies',
    ),
    ActivityItem(
      id: 'act-2',
      title: 'Follow up on Enterprise Quote SLA',
      type: ActivityType.call,
      scheduledAt: DateTime.now().add(const Duration(hours: 3)),
      entityName: 'Samantha Reed',
    ),
    ActivityItem(
      id: 'act-3',
      title: 'Review Legal Master Service Agreement',
      type: ActivityType.task,
      scheduledAt: DateTime.now().add(const Duration(hours: 5)),
      entityName: 'Global ERP Migration',
    ),
    ActivityItem(
      id: 'act-4',
      title: 'Send GST compliant invoice',
      type: ActivityType.task,
      scheduledAt: DateTime.now().subtract(const Duration(hours: 2)),
      entityName: 'Tata Enterprises',
      isCompleted: true,
    ),
  ];

  Future<List<ActivityItem>> getActivities() async {
    return _activities;
  }

  Future<void> toggleComplete(String id) async {
    final idx = _activities.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = _activities[idx];
      _activities[idx] = ActivityItem(
        id: old.id,
        title: old.title,
        type: old.type,
        scheduledAt: old.scheduledAt,
        entityName: old.entityName,
        isCompleted: !old.isCompleted,
      );
    }
  }

  Future<ActivityItem> createActivity(String title, ActivityType type, String entityName) async {
    final item = ActivityItem(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: type,
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
      entityName: entityName,
    );
    _activities.insert(0, item);
    return item;
  }
}
