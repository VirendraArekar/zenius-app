class AttendanceRecord {
  final String id;
  final String employeeName;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double latitude;
  final double longitude;
  final String locationAddress;
  final bool isMockLocation;
  final String status; // ON_TIME, LATE, HALF_DAY

  const AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.checkInTime,
    this.checkOutTime,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
    required this.isMockLocation,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      employeeName: json['employeeName'] ?? 'Employee',
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime']) ?? DateTime.now()
          : DateTime.now(),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'])
          : null,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 37.7749,
      longitude: (json['longitude'] as num?)?.toDouble() ?? -122.4194,
      locationAddress: json['locationAddress'] ?? 'San Francisco HQ, CA',
      isMockLocation: json['isMockLocation'] ?? false,
      status: json['status'] ?? 'ON_TIME',
    );
  }
}

class LeaveApplication {
  final String id;
  final String leaveType; // CASUAL, SICK, PAID, MATERNITY
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // PENDING, APPROVED, REJECTED

  const LeaveApplication({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });
}
