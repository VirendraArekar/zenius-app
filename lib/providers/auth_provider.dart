import 'package:flutter/material.dart';
import '../data/models/auth_user.dart';
import '../data/models/organization.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository}) {
    _currentOrg = AuthRepository.availableOrgs.first;
  }

  AuthUser? _user;
  Organization? _currentOrg;
  bool _isAuthenticated = true; // Auto-auth in demo mode for instant evaluation
  bool _isDarkMode = false;
  List<Organization> get organizations => AuthRepository.availableOrgs;

  AuthUser? get user => _user ?? const AuthUser(
        id: 'usr-admin-1',
        email: 'admin@zenius.com',
        fullName: 'Virendra Arekar',
        role: 'SUPER_ADMIN',
        mfaEnabled: true,
        organizationId: 'org-acme-prod',
      );

  Organization? get currentOrg => _currentOrg;
  bool get isAuthenticated => _isAuthenticated;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> switchOrganization(Organization org) async {
    _currentOrg = org;
    await authRepository.switchOrganization(org.id);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _user = await authRepository.login(email, password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<bool> verifyMfa(String code) async {
    return await authRepository.verifyMfa(code);
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
