class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final bool mfaEnabled;
  final String organizationId;

  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.mfaEnabled,
    required this.organizationId,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['name'] ?? 'Executive User',
      role: json['role'] ?? 'SUPER_ADMIN',
      mfaEnabled: json['mfaEnabled'] ?? true,
      organizationId: json['organizationId'] ?? 'org-acme-prod',
    );
  }
}
