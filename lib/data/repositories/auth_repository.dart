import '../models/auth_user.dart';
import '../models/organization.dart';
import '../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  static const List<Organization> availableOrgs = [
    Organization(
      id: 'org-acme-prod',
      name: 'Acme Global Corp',
      slug: 'acme-global',
      currency: 'USD',
      currencySymbol: '\$',
      country: 'United States',
      plan: 'Enterprise Cloud',
    ),
    Organization(
      id: 'org-zenius-india',
      name: 'Zenius India Pvt Ltd',
      slug: 'zenius-india',
      currency: 'INR',
      currencySymbol: '₹',
      country: 'India',
      plan: 'Enterprise Cloud',
    ),
  ];

  Future<AuthUser> login(String email, String password) async {
    // Attempt backend login
    final res = await apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (res != null) {
      apiClient.authToken = res['accessToken'] ?? 'demo-token';
      return AuthUser.fromJson(res['user'] ?? {});
    }

    // High fidelity demo fallback
    apiClient.authToken = 'mock-jwt-token-active';
    return const AuthUser(
      id: 'usr-admin-1',
      email: 'admin@zenius.com',
      fullName: 'Virendra Arekar',
      role: 'SUPER_ADMIN',
      mfaEnabled: true,
      organizationId: 'org-acme-prod',
    );
  }

  Future<bool> verifyMfa(String code) async {
    final res = await apiClient.post('/auth/mfa/verify', {'totpCode': code});
    if (res != null) return true;
    return code.length == 6; // Mock accept 6-digit TOTP
  }

  Future<void> switchOrganization(String orgId) async {
    apiClient.currentOrgId = orgId;
    await apiClient.post('/organizations/$orgId/switch', {});
  }
}
