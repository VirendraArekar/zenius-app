import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../data/models/activity.dart';
import '../../providers/activity_provider.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityProvider>().loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final act = context.watch<ActivityProvider>();
    final activities = act.activities;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities & Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () => _showAddActivityDialog(context),
          ),
        ],
      ),
      body: act.isLoading && activities.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, idx) {
                final item = activities[idx];
                return _buildActivityTile(context, item, isDark);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showAddActivityDialog(context),
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, ActivityItem item, bool isDark) {
    Color typeColor;
    IconData typeIcon;
    switch (item.type) {
      case ActivityType.meeting:
        typeColor = AppColors.primary;
        typeIcon = Icons.groups_outlined;
        break;
      case ActivityType.call:
        typeColor = AppColors.secondary;
        typeIcon = Icons.call_outlined;
        break;
      case ActivityType.task:
        typeColor = AppColors.accent;
        typeIcon = Icons.check_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              item.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: item.isCompleted ? AppColors.success : Colors.grey,
            ),
            onPressed: () => context.read<ActivityProvider>().toggleComplete(item.id),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    color: item.isCompleted ? Colors.grey : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(typeIcon, size: 12, color: typeColor),
                          const SizedBox(width: 4),
                          Text(
                            item.type.name.toUpperCase(),
                            style: TextStyle(color: typeColor, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.entityName,
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.jm().format(item.scheduledAt),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddActivityDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final entityCtrl = TextEditingController();
    ActivityType type = ActivityType.meeting;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Schedule Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Activity Title *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: entityCtrl,
                decoration: const InputDecoration(labelText: 'Related Client / Deal'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<ActivityType>(
                value: type,
                decoration: const InputDecoration(labelText: 'Activity Type'),
                items: const [
                  DropdownMenuItem(value: ActivityType.meeting, child: Text('Meeting')),
                  DropdownMenuItem(value: ActivityType.call, child: Text('Phone Call')),
                  DropdownMenuItem(value: ActivityType.task, child: Text('Task / To-Do')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => type = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                context.read<ActivityProvider>().createActivity(
                  titleCtrl.text.trim(),
                  type,
                  entityCtrl.text.trim().isNotEmpty ? entityCtrl.text.trim() : 'General',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity added to your agenda.')),
                );
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
