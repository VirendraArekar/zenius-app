import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/attendance_provider.dart';
import '../dialogs/apply_leave_dialog.dart';

class GeoCheckinScreen extends StatefulWidget {
  const GeoCheckinScreen({super.key});

  @override
  State<GeoCheckinScreen> createState() => _GeoCheckinScreenState();
}

class _GeoCheckinScreenState extends State<GeoCheckinScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().loadState();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final att = context.watch<AttendanceProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Geo Check-In & Attendance'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'GPS Check-In'),
            Tab(text: 'Leave Management'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCheckinTab(context, att, isDark),
          _buildLeaveTab(context, att, isDark),
        ],
      ),
    );
  }

  Widget _buildCheckinTab(BuildContext context, AttendanceProvider att, bool isDark) {
    final isCheckedIn = att.isCheckedIn;
    final today = att.todayRecord;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GPS Anti-Spoof Accuracy Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_outlined, size: 16, color: AppColors.success),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'GPS Accuracy High (4m) • Anti-Spoof Guard Verified',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Central Check-In / Check-Out Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCheckedIn
                    ? [const Color(0xFF065F46), const Color(0xFF047857), const Color(0xFF059669)]
                    : [const Color(0xFF1E1B4B), const Color(0xFF312E81), const Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (isCheckedIn ? AppColors.success : AppColors.primary).withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: Icon(
                    isCheckedIn ? Icons.how_to_reg_rounded : Icons.location_on_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isCheckedIn ? 'Currently Checked In' : 'Ready to Check In',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  isCheckedIn && today != null
                      ? 'Since ${DateFormat.jm().format(today.checkInTime)}'
                      : 'Record your field sales GPS attendance',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isCheckedIn ? AppColors.danger : AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: att.isLoading
                        ? null
                        : () {
                            if (isCheckedIn) {
                              att.checkOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Successfully checked out.')),
                              );
                            } else {
                              att.checkIn();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Geo Check-in recorded at San Francisco HQ.')),
                              );
                            }
                          },
                    child: Text(
                      isCheckedIn ? 'CHECK OUT NOW' : 'GEO CHECK IN NOW',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Location Verification Card
          Text('Location & Geofencing Details', style: AppTypography.titleMedium(context)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              children: [
                _buildGeoInfoRow(
                  icon: Icons.business_outlined,
                  title: 'Assigned Site',
                  value: 'San Francisco HQ, 500 Howard St, CA',
                  isDark: isDark,
                ),
                const Divider(height: 20),
                _buildGeoInfoRow(
                  icon: Icons.my_location,
                  title: 'GPS Coordinates',
                  value: '37.7749° N, 122.4194° W',
                  isDark: isDark,
                ),
                const Divider(height: 20),
                _buildGeoInfoRow(
                  icon: Icons.shield_outlined,
                  title: 'Mock Location Guard',
                  value: 'Active (Strictly Enforced)',
                  isDark: isDark,
                  valueColor: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTab(BuildContext context, AttendanceProvider att, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leave Balance Cards
          Row(
            children: [
              _buildLeaveBalanceCard('Paid Leave', '14', 'days left', AppColors.primary, isDark),
              const SizedBox(width: 8),
              _buildLeaveBalanceCard('Casual', '8', 'days left', AppColors.secondary, isDark),
              const SizedBox(width: 8),
              _buildLeaveBalanceCard('Sick Leave', '5', 'days left', AppColors.accent, isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Apply Leave Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Apply for Leave', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => const ApplyLeaveDialog(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Leave History List
          Text('Leave Applications History', style: AppTypography.titleMedium(context)),
          const SizedBox(height: 10),
          ...att.leaves.map((leave) => Container(
                margin: const EdgeInsets.only(bottom: 10),
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
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${leave.leaveType} LEAVE',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (leave.status == 'APPROVED' ? AppColors.success : AppColors.accent).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  leave.status,
                                  style: TextStyle(
                                    color: leave.status == 'APPROVED' ? AppColors.success : AppColors.accent,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${DateFormat('MMM d').format(leave.startDate)} - ${DateFormat('MMM d, yyyy').format(leave.endDate)}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            leave.reason,
                            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceCard(String title, String count, String unit, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary)),
            const SizedBox(height: 4),
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(unit, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildGeoInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
