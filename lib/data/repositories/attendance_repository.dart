import '../models/attendance_record.dart';
import '../../core/network/api_client.dart';

class AttendanceRepository {
  final ApiClient apiClient;

  AttendanceRepository({required this.apiClient});

  AttendanceRecord? _todayRecord;
  final List<LeaveApplication> _leaves = [
    LeaveApplication(
      id: 'leave-1',
      leaveType: 'PAID',
      startDate: DateTime.now().add(const Duration(days: 4)),
      endDate: DateTime.now().add(const Duration(days: 6)),
      reason: 'Annual family vacation',
      status: 'APPROVED',
    ),
    LeaveApplication(
      id: 'leave-2',
      leaveType: 'SICK',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 9)),
      reason: 'Viral fever rest',
      status: 'APPROVED',
    ),
  ];

  Future<AttendanceRecord?> getTodayAttendance() async {
    return _todayRecord;
  }

  Future<AttendanceRecord> checkIn({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final record = AttendanceRecord(
      id: 'att-${DateTime.now().millisecondsSinceEpoch}',
      employeeName: 'Virendra Arekar',
      checkInTime: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      locationAddress: address,
      isMockLocation: false,
      status: 'ON_TIME',
    );
    _todayRecord = record;
    apiClient.post('/hr/attendance/check-in', {
      'latitude': latitude,
      'longitude': longitude,
      'locationAddress': address,
    });
    return record;
  }

  Future<AttendanceRecord> checkOut() async {
    final updated = AttendanceRecord(
      id: _todayRecord?.id ?? 'att-now',
      employeeName: _todayRecord?.employeeName ?? 'Virendra Arekar',
      checkInTime: _todayRecord?.checkInTime ?? DateTime.now().subtract(const Duration(hours: 8)),
      checkOutTime: DateTime.now(),
      latitude: _todayRecord?.latitude ?? 37.7749,
      longitude: _todayRecord?.longitude ?? -122.4194,
      locationAddress: _todayRecord?.locationAddress ?? 'San Francisco HQ, CA',
      isMockLocation: false,
      status: 'COMPLETED',
    );
    _todayRecord = updated;
    apiClient.post('/hr/attendance/check-out', {});
    return updated;
  }

  Future<List<LeaveApplication>> getLeaves() async {
    return _leaves;
  }

  Future<LeaveApplication> applyLeave({
    required String type,
    required DateTime start,
    required DateTime end,
    required String reason,
  }) async {
    final leave = LeaveApplication(
      id: 'leave-${DateTime.now().millisecondsSinceEpoch}',
      leaveType: type,
      startDate: start,
      endDate: end,
      reason: reason,
      status: 'PENDING',
    );
    _leaves.insert(0, leave);
    apiClient.post('/hr/leaves', {
      'leaveType': type,
      'startDate': start.toIso8601String(),
      'endDate': end.toIso8601String(),
      'reason': reason,
    });
    return leave;
  }
}
