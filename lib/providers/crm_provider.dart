import 'package:flutter/foundation.dart';
import '../data/models/lead.dart';
import '../data/models/deal.dart';
import '../data/repositories/crm_repository.dart';

class CrmProvider extends ChangeNotifier {
  final CrmRepository crmRepository;

  CrmProvider({required this.crmRepository});

  List<Lead> _leads = [];
  List<Deal> _deals = [];
  bool _isLoading = false;
  String _selectedStage = 'ALL';
  String _leadSearchQuery = '';

  List<Lead> get leads {
    if (_leadSearchQuery.isEmpty) return _leads;
    final q = _leadSearchQuery.toLowerCase();
    return _leads.where((l) =>
        l.fullName.toLowerCase().contains(q) ||
        (l.companyName?.toLowerCase().contains(q) ?? false)).toList();
  }

  List<Deal> get deals {
    if (_selectedStage == 'ALL') return _deals;
    return _deals.where((d) => d.stageName == _selectedStage).toList();
  }

  double get totalPipelineAmount =>
      _deals.fold(0.0, (acc, d) => acc + d.amount);

  double get weightedForecast => _deals.fold(
      0.0, (acc, d) => acc + (d.amount * (d.probability / 100.0)));

  bool get isLoading => _isLoading;
  String get selectedStage => _selectedStage;

  void setStageFilter(String stage) {
    _selectedStage = stage;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _leadSearchQuery = q;
    notifyListeners();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _leads = await crmRepository.getLeads();
      _deals = await crmRepository.getDeals();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createLead(Map<String, dynamic> data) async {
    await crmRepository.createLead(data);
    await loadData();
  }

  Future<void> createDeal(Map<String, dynamic> data) async {
    await crmRepository.createDeal(data);
    await loadData();
  }

  Future<void> convertLead(String leadId, String dealTitle) async {
    await crmRepository.convertLead(leadId, dealTitle);
    await loadData();
  }
}
