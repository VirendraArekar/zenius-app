import '../models/lead.dart';
import '../models/deal.dart';
import '../models/executive_pulse.dart';
import '../../core/network/api_client.dart';

class CrmRepository {
  final ApiClient apiClient;

  CrmRepository({required this.apiClient});

  // Cached state for instant mobile UI responsiveness
  final List<Lead> _leads = [
    Lead(
      id: 'lead-1',
      fullName: 'Samantha Reed',
      email: 'samantha@apextech.io',
      companyName: 'Apex Technologies',
      source: 'WEBSITE',
      leadScore: 92,
      status: 'QUALIFIED',
      estimatedValue: 45000.0,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Lead(
      id: 'lead-2',
      fullName: 'Rahul Sharma',
      email: 'rahul.s@tata-enterprises.com',
      companyName: 'Tata Enterprises',
      source: 'REFERRAL',
      leadScore: 88,
      status: 'CONTACTED',
      estimatedValue: 72000.0,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    Lead(
      id: 'lead-3',
      fullName: 'Elena Rostova',
      email: 'elena@novacorp.de',
      companyName: 'Nova Systems GmbH',
      source: 'PARTNER',
      leadScore: 96,
      status: 'NEW',
      estimatedValue: 120000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Lead(
      id: 'lead-4',
      fullName: 'Marcus Vance',
      email: 'mvance@cloudscale.net',
      companyName: 'CloudScale Inc',
      source: 'OUTBOUND',
      leadScore: 65,
      status: 'CONTACTED',
      estimatedValue: 33000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<Deal> _deals = [
    const Deal(
      id: 'deal-1',
      title: 'Global ERP Migration',
      amount: 145000.0,
      stageName: 'Proposal',
      probability: 70,
      accountName: 'Novartis Global',
    ),
    const Deal(
      id: 'deal-2',
      title: 'Field Sales Automation License',
      amount: 68000.0,
      stageName: 'Negotiation',
      probability: 85,
      accountName: 'Apex Technologies',
    ),
    const Deal(
      id: 'deal-3',
      title: 'Cloud PBX & AI Receptionist',
      amount: 32000.0,
      stageName: 'Qualification',
      probability: 40,
      accountName: 'CloudScale Inc',
    ),
    const Deal(
      id: 'deal-4',
      title: 'Enterprise CRM Annual Contract',
      amount: 95000.0,
      stageName: 'Closed Won',
      probability: 100,
      accountName: 'Tata Enterprises',
    ),
  ];

  Future<ExecutivePulse> getExecutivePulse() async {
    final res = await apiClient.get('/intelligence/pulse');
    if (res != null) {
      return ExecutivePulse.fromJson(res);
    }
    // High-fidelity fallback
    return const ExecutivePulse(
      pipelineValue: 340000.0,
      dealCount: 4,
      leadCount: 4,
      totalInvoiced: 168000.0,
      totalReceivable: 42000.0,
      employeeHeadcount: 32,
      completedTasks: 21,
      totalTasks: 28,
      openTickets: 2,
      moduleBreakdown: [
        SuiteVolume(label: 'CRM Deals', count: 4, amount: 340000),
        SuiteVolume(label: 'Invoices', count: 12, amount: 168000),
        SuiteVolume(label: 'Workforce', count: 32, amount: 0),
        SuiteVolume(label: 'Support SLA', count: 2, amount: 0),
        SuiteVolume(label: 'Sprint Tasks', count: 28, amount: 0),
      ],
    );
  }

  Future<List<Lead>> getLeads() async {
    final res = await apiClient.get('/crm/leads');
    if (res is List) {
      return res.map((e) => Lead.fromJson(e)).toList();
    }
    return _leads;
  }

  Future<Lead> createLead(Map<String, dynamic> data) async {
    final newLead = Lead(
      id: 'lead-${DateTime.now().millisecondsSinceEpoch}',
      fullName: data['fullName'],
      email: data['email'],
      companyName: data['companyName'],
      source: data['source'] ?? 'MOBILE',
      leadScore: 75,
      status: 'NEW',
      estimatedValue: (data['estimatedValue'] as num?)?.toDouble() ?? 25000.0,
      createdAt: DateTime.now(),
    );
    _leads.insert(0, newLead);
    apiClient.post('/crm/leads', data);
    return newLead;
  }

  Future<List<Deal>> getDeals() async {
    final res = await apiClient.get('/crm/deals');
    if (res is List) {
      return res.map((e) => Deal.fromJson(e)).toList();
    }
    return _deals;
  }

  Future<Deal> createDeal(Map<String, dynamic> data) async {
    final newDeal = Deal(
      id: 'deal-${DateTime.now().millisecondsSinceEpoch}',
      title: data['title'] ?? 'New Opportunity',
      amount: (data['amount'] as num?)?.toDouble() ?? 20000.0,
      stageName: data['stageName'] ?? 'Qualification',
      probability: 40,
      accountName: data['accountName'] ?? 'New Account',
    );
    _deals.insert(0, newDeal);
    apiClient.post('/crm/deals', data);
    return newDeal;
  }

  Future<void> convertLead(String leadId, String dealTitle) async {
    final idx = _leads.indexWhere((l) => l.id == leadId);
    if (idx != -1) {
      final old = _leads[idx];
      _leads[idx] = Lead(
        id: old.id,
        fullName: old.fullName,
        email: old.email,
        companyName: old.companyName,
        source: old.source,
        leadScore: old.leadScore,
        status: 'CONVERTED',
        estimatedValue: old.estimatedValue,
        createdAt: old.createdAt,
      );
      _deals.insert(
        0,
        Deal(
          id: 'deal-${DateTime.now().millisecondsSinceEpoch}',
          title: dealTitle,
          amount: old.estimatedValue ?? 35000.0,
          stageName: 'Qualification',
          probability: 40,
          accountName: old.companyName,
        ),
      );
      apiClient.post('/crm/leads/$leadId/convert', {'createDeal': true, 'dealTitle': dealTitle});
    }
  }
}
