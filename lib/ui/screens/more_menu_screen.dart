import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../dialogs/org_switcher_sheet.dart';
import 'activities_screen.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOrg = auth.currentOrg;

    return Scaffold(
      appBar: AppBar(title: const Text('Menu & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current User & Active Organization Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Text(
                          auth.user?.fullName.substring(0, 1) ?? 'V',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(auth.user?.fullName ?? 'Virendra Arekar', style: AppTypography.titleMedium(context)),
                            Text(auth.user?.email ?? 'admin@zenius.com', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                auth.user?.role ?? 'SUPER_ADMIN',
                                style: const TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Organization Switcher Pill
                  InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => const OrgSwitcherSheet(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.business_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Active Organization', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                Text(
                                  '${currentOrg?.name ?? "Acme Global"} (${currentOrg?.currency ?? "USD"})',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Modules & Settings List
            _buildMenuItem(
              context,
              icon: Icons.calendar_month_outlined,
              title: 'Activities & Meetings Agenda',
              subtitle: 'Calls, customer appointments and tasks',
              color: AppColors.primary,
              isDark: isDark,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivitiesScreen()),
              ),
            ),
            _buildMenuItem(
              context,
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode Theme',
              subtitle: isDark ? 'Currently using Dark theme' : 'Currently using Light theme',
              color: AppColors.secondary,
              isDark: isDark,
              trailing: Switch(
                value: isDark,
                onChanged: (_) => auth.toggleTheme(),
              ),
            ),
            _buildMenuItem(
              context,
              icon: Icons.security_outlined,
              title: 'Security & TOTP MFA',
              subtitle: 'Multi-factor authentication active',
              color: AppColors.success,
              isDark: isDark,
            ),
            _buildMenuItem(
              context,
              icon: Icons.cloud_done_outlined,
              title: 'Backend Microservices Architecture',
              subtitle: '5 Services · Spring Gateway :8080 · Isolated schemas',
              color: AppColors.violet,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
    );
  }
}
