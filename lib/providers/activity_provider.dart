import 'package:flutter/foundation.dart';
import '../data/models/activity.dart';
import '../data/repositories/activity_repository.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository activityRepository;

  ActivityProvider({required this.activityRepository});

  List<ActivityItem> _activities = [];
  bool _isLoading = false;

  List<ActivityItem> get activities => _activities;
  bool get isLoading => _isLoading;

  Future<void> loadActivities() async {
    _isLoading = true;
    notifyListeners();
    try {
      _activities = await activityRepository.getActivities();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleComplete(String id) async {
    await activityRepository.toggleComplete(id);
    _activities = await activityRepository.getActivities();
    notifyListeners();
  }

  Future<void> createActivity(String title, ActivityType type, String entityName) async {
    await activityRepository.createActivity(title, type, entityName);
    _activities = await activityRepository.getActivities();
    notifyListeners();
  }
}
