class Deal {
  final String id;
  final String title;
  final double amount;
  final String stageName;
  final int probability;
  final String? accountName;
  final DateTime? expectedCloseDate;

  const Deal({
    required this.id,
    required this.title,
    required this.amount,
    required this.stageName,
    required this.probability,
    this.accountName,
    this.expectedCloseDate,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Opportunity',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      stageName: json['stageName'] ?? json['stage'] ?? 'Qualification',
      probability: (json['probability'] as num?)?.toInt() ?? 40,
      accountName: json['accountName'] ?? json['account']?['name'],
      expectedCloseDate: json['expectedCloseDate'] != null
          ? DateTime.tryParse(json['expectedCloseDate'])
          : null,
    );
  }
}

class DealStageSummary {
  final String stageName;
  final int dealCount;
  final double totalAmount;

  const DealStageSummary({
    required this.stageName,
    required this.dealCount,
    required this.totalAmount,
  });

  factory DealStageSummary.fromJson(Map<String, dynamic> json) {
    return DealStageSummary(
      stageName: json['stageName'] ?? 'Stage',
      dealCount: (json['dealCount'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
