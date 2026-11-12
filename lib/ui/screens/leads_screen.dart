import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/crm_provider.dart';
import '../../data/models/lead.dart';
import 'lead_detail_screen.dart';
import '../dialogs/create_lead_dialog.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();
    final leads = crm.leads;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => const CreateLeadDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => crm.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search leads by name or company...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                fillColor: isDark ? AppColors.darkCard : Colors.white,
              ),
            ),
          ),

          // Leads List View
          Expanded(
            child: crm.isLoading && leads.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : leads.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            const Text('No leads found'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: leads.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, idx) {
                          final lead = leads[idx];
                          return _buildLeadTile(context, lead, isDark);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Lead', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => const CreateLeadDialog(),
        ),
      ),
    );
  }

  Widget _buildLeadTile(BuildContext context, Lead lead, bool isDark) {
    final scoreColor = lead.leadScore >= 80
        ? AppColors.success
        : lead.leadScore >= 50
            ? AppColors.accent
            : AppColors.danger;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LeadDetailScreen(lead: lead)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            // Score avatar circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: scoreColor.withOpacity(0.4)),
              ),
              child: Center(
                child: Text(
                  '${lead.leadScore}',
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Lead Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lead.fullName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: lead.status == 'CONVERTED'
                              ? AppColors.success.withOpacity(0.12)
                              : AppColors.info.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lead.status,
                          style: TextStyle(
                            color: lead.status == 'CONVERTED' ? AppColors.success : AppColors.info,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lead.companyName ?? lead.email ?? 'No company recorded',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.source_outlined, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        lead.source,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                      if (lead.estimatedValue != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          '•  \$${lead.estimatedValue!.toInt()}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Quick Call Button
            IconButton(
              icon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling ${lead.fullName}...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
