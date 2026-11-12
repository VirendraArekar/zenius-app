import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/auth_provider.dart';
import '../common/colorful_chart.dart';
import '../common/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({super.key, required this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadPulse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();
    final auth = context.watch<AuthProvider>();
    final pulse = dash.pulse;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencySym = auth.currentOrg?.currencySymbol ?? '\$';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'OPERATIONAL',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                auth.currentOrg?.name ?? 'Acme Global Corp',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => dash.loadPulse(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All real-time notification streams synced.')),
              );
            },
          ),
        ],
      ),
      body: dash.isLoading && pulse == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => dash.loadPulse(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Executive Command Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Executive Command Center',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.auto_awesome, color: AppColors.secondary, size: 20),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Live cross-suite revenue, pipeline, geo-attendance, and AI operations.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildQuickActionButton(
                                context,
                                icon: Icons.location_on_outlined,
                                label: 'Geo Check-In',
                                color: AppColors.success,
                                onTap: () => widget.onNavigateTab(2), // Attendance tab
                              ),
                              const SizedBox(width: 8),
                              _buildQuickActionButton(
                                context,
                                icon: Icons.chat_bubble_outline,
                                label: 'Ask Zenius AI',
                                color: AppColors.secondary,
                                onTap: () => widget.onNavigateTab(3), // AI Chat tab
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Executive Metric KPI Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: [
                        MetricCard(
                          title: 'Sales Pipeline',
                          value: '$currencySym${NumberFormat.compact().format(pulse?.pipelineValue ?? 340000)}',
                          subtitle: '${pulse?.dealCount ?? 4} deals · ${pulse?.leadCount ?? 4} leads',
                          icon: Icons.trending_up,
                          accentColor: AppColors.primary,
                          onTap: () => widget.onNavigateTab(1), // CRM tab
                        ),
                        MetricCard(
                          title: 'Invoiced Revenue',
                          value: '$currencySym${NumberFormat.compact().format(pulse?.totalInvoiced ?? 168000)}',
                          subtitle: '$currencySym${NumberFormat.compact().format(pulse?.totalReceivable ?? 42000)} receivable',
                          icon: Icons.account_balance_outlined,
                          accentColor: AppColors.success,
                        ),
                        MetricCard(
                          title: 'Active Workforce',
                          value: '${pulse?.employeeHeadcount ?? 32}',
                          subtitle: '${pulse?.completedTasks ?? 21}/${pulse?.totalTasks ?? 28} tasks done',
                          icon: Icons.badge_outlined,
                          accentColor: AppColors.secondary,
                          onTap: () => widget.onNavigateTab(2),
                        ),
                        MetricCard(
                          title: 'Support SLA Queue',
                          value: '${pulse?.openTickets ?? 2}',
                          subtitle: 'Open customer tickets',
                          icon: Icons.support_agent_outlined,
                          accentColor: AppColors.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Real-Time Operations Volume & Resource Breakdown with fl_chart
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dash.isDonutMode ? 'Tenant Portfolio Share' : 'Operations Record Volume',
                                    style: AppTypography.titleMedium(context),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Real-time distribution across active suites',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text('Bars', style: TextStyle(fontSize: 10)),
                                    selected: !dash.isDonutMode,
                                    onSelected: (_) => dash.toggleChartMode(),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const SizedBox(width: 4),
                                  ChoiceChip(
                                    label: const Text('Donut', style: TextStyle(fontSize: 10)),
                                    selected: dash.isDonutMode,
                                    onSelected: (_) => dash.toggleChartMode(),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ColorfulChartSection(
                            data: pulse?.moduleBreakdown ?? [],
                            isDonut: dash.isDonutMode,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Today's Agenda & Smart Feed (Zoho CRM Home style)
                    Text('Today\'s Agenda & Feed', style: AppTypography.titleMedium(context)),
                    const SizedBox(height: 10),
                    _buildFeedCard(
                      context,
                      isDark: isDark,
                      icon: Icons.video_call_outlined,
                      title: 'Product Demo & Architecture Walkthrough',
                      subtitle: 'With Apex Technologies (11:30 AM - 12:15 PM)',
                      badge: 'High Priority',
                      badgeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    _buildFeedCard(
                      context,
                      isDark: isDark,
                      icon: Icons.phone_forwarded_outlined,
                      title: 'Follow-up with Samantha Reed',
                      subtitle: 'Apex Technologies · Lead Score: 92/100',
                      badge: 'Hot Lead',
                      badgeColor: AppColors.success,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: badgeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(color: badgeColor, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
