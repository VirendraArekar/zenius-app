import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/crm_provider.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/deal.dart';
import '../dialogs/create_deal_dialog.dart';

class DealsPipelineScreen extends StatelessWidget {
  const DealsPipelineScreen({super.key});

  static const List<String> stages = [
    'ALL',
    'Qualification',
    'Proposal',
    'Negotiation',
    'Closed Won',
  ];

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();
    final auth = context.watch<AuthProvider>();
    final deals = crm.deals;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencySym = auth.currentOrg?.currencySymbol ?? '\$';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals Pipeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_chart_outlined),
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => const CreateDealDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pipeline Summary Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Open Pipeline',
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$currencySym${NumberFormat.currency(symbol: '', decimalDigits: 0).format(crm.totalPipelineAmount)}',
                        style: AppTypography.titleLarge(context).copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Container(height: 32, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weighted Forecast',
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$currencySym${NumberFormat.currency(symbol: '', decimalDigits: 0).format(crm.weightedForecast)}',
                        style: AppTypography.titleLarge(context).copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stage Chips (Zoho CRM Pipeline style)
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: stages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, idx) {
                final stage = stages[idx];
                final isSelected = crm.selectedStage == stage;
                final color = stage == 'ALL' ? AppColors.primary : AppColors.getStageColor(stage);

                return FilterChip(
                  label: Text(stage),
                  selected: isSelected,
                  selectedColor: color.withOpacity(0.18),
                  checkmarkColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? color : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  onSelected: (_) => crm.setStageFilter(stage),
                );
              },
            ),
          ),

          // Deals List
          Expanded(
            child: deals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_none, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('No deals in ${crm.selectedStage} stage'),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: deals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, idx) {
                      final deal = deals[idx];
                      return _buildDealCard(context, deal, currencySym, isDark);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Deal', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => const CreateDealDialog(),
        ),
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, Deal deal, String currencySym, bool isDark) {
    final stageColor = AppColors.getStageColor(deal.stageName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  deal.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$currencySym${NumberFormat.currency(symbol: '', decimalDigits: 0).format(deal.amount)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            deal.accountName ?? 'Enterprise Client',
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
          ),
          const SizedBox(height: 12),

          // Probability Progress bar & Stage badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: stageColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  deal.stageName,
                  style: TextStyle(color: stageColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: deal.probability / 100.0,
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(stageColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${deal.probability}%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: stageColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
