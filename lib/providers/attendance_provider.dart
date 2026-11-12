import 'package:flutter/foundation.dart';
import '../data/models/attendance_record.dart';
import '../data/repositories/attendance_repository.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepository attendanceRepository;

  AttendanceProvider({required this.attendanceRepository});

  AttendanceRecord? _todayRecord;
  List<LeaveApplication> _leaves = [];
  bool _isLoading = false;

  AttendanceRecord? get todayRecord => _todayRecord;
  List<LeaveApplication> get leaves => _leaves;
  bool get isLoading => _isLoading;
  bool get isCheckedIn => _todayRecord != null && _todayRecord!.checkOutTime == null;

  Future<void> loadState() async {
    _isLoading = true;
    notifyListeners();
    try {
      _todayRecord = await attendanceRepository.getTodayAttendance();
      _leaves = await attendanceRepository.getLeaves();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIn({
    double latitude = 37.7749,
    double longitude = -122.4194,
    String address = 'San Francisco HQ, 500 Howard St, CA',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _todayRecord = await attendanceRepository.checkIn(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      _todayRecord = await attendanceRepository.checkOut();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyLeave({
    required String type,
    required DateTime start,
    required DateTime end,
    required String reason,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await attendanceRepository.applyLeave(
        type: type,
        start: start,
        end: end,
        reason: reason,
      );
      _leaves = await attendanceRepository.getLeaves();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
