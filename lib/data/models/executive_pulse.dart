class ExecutivePulse {
  final double pipelineValue;
  final int dealCount;
  final int leadCount;
  final double totalInvoiced;
  final double totalReceivable;
  final int employeeHeadcount;
  final int completedTasks;
  final int totalTasks;
  final int openTickets;
  final List<SuiteVolume> moduleBreakdown;

  const ExecutivePulse({
    required this.pipelineValue,
    required this.dealCount,
    required this.leadCount,
    required this.totalInvoiced,
    required this.totalReceivable,
    required this.employeeHeadcount,
    required this.completedTasks,
    required this.totalTasks,
    required this.openTickets,
    required this.moduleBreakdown,
  });

  factory ExecutivePulse.fromJson(Map<String, dynamic> json) {
    var rawList = json['moduleBreakdown'] as List? ?? [];
    var breakdown = rawList.map((e) => SuiteVolume.fromJson(e)).toList();
    return ExecutivePulse(
      pipelineValue: (json['pipelineValue'] as num?)?.toDouble() ?? 270000.0,
      dealCount: (json['dealCount'] as num?)?.toInt() ?? 8,
      leadCount: (json['leadCount'] as num?)?.toInt() ?? 14,
      totalInvoiced: (json['totalInvoiced'] as num?)?.toDouble() ?? 142000.0,
      totalReceivable: (json['totalReceivable'] as num?)?.toDouble() ?? 38500.0,
      employeeHeadcount: (json['employeeHeadcount'] as num?)?.toInt() ?? 24,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 19,
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 25,
      openTickets: (json['openTickets'] as num?)?.toInt() ?? 3,
      moduleBreakdown: breakdown,
    );
  }
}

class SuiteVolume {
  final String label;
  final int count;
  final double amount;

  const SuiteVolume({
    required this.label,
    required this.count,
    required this.amount,
  });

  factory SuiteVolume.fromJson(Map<String, dynamic> json) {
    return SuiteVolume(
      label: json['label'] ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
