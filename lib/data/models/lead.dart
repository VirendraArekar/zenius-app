class Lead {
  final String id;
  final String fullName;
  final String? email;
  final String? companyName;
  final String source;
  final int leadScore;
  final String status; // NEW, CONTACTED, QUALIFIED, CONVERTED
  final double? estimatedValue;
  final DateTime createdAt;

  const Lead({
    required this.id,
    required this.fullName,
    this.email,
    this.companyName,
    required this.source,
    required this.leadScore,
    required this.status,
    this.estimatedValue,
    required this.createdAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? 'Unknown Lead',
      email: json['email'],
      companyName: json['companyName'],
      source: json['source'] ?? 'WEBSITE',
      leadScore: (json['leadScore'] as num?)?.toInt() ?? 50,
      status: json['status'] ?? 'NEW',
      estimatedValue: (json['estimatedValue'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
