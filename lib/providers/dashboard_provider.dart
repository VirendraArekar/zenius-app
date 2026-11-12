import 'package:flutter/foundation.dart';
import '../data/models/executive_pulse.dart';
import '../data/repositories/crm_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final CrmRepository crmRepository;

  DashboardProvider({required this.crmRepository});

  ExecutivePulse? _pulse;
  bool _isLoading = false;
  bool _isDonutMode = false;
  String? _error;

  ExecutivePulse? get pulse => _pulse;
  bool get isLoading => _isLoading;
  bool get isDonutMode => _isDonutMode;
  String? get error => _error;

  void toggleChartMode() {
    _isDonutMode = !_isDonutMode;
    notifyListeners();
  }

  Future<void> loadPulse() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pulse = await crmRepository.getExecutivePulse();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
