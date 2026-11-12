import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/executive_pulse.dart';

class ColorfulChartSection extends StatelessWidget {
  final List<SuiteVolume> data;
  final bool isDonut;

  const ColorfulChartSection({
    super.key,
    required this.data,
    required this.isDonut,
  });

  static const List<Color> palette = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Rose
    Color(0xFF8B5CF6), // Violet
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Loading analytics...')),
      );
    }

    if (isDonut) {
      return SizedBox(
        height: 190,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: data.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final color = palette[idx % palette.length];
                    return PieChartSectionData(
                      color: color,
                      value: item.count.toDouble() > 0 ? item.count.toDouble() : 1.0,
                      title: '${item.count}',
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final color = palette[idx % palette.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    // Colorful Bar Chart
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.map((e) => e.count).fold<int>(0, (a, b) => a > b ? a : b) + 5).toDouble(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = data[group.x.toInt()];
                return BarTooltipItem(
                  '${item.label}\n${item.count} items',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (val, meta) => Text(
                  val.toInt().toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  if (idx >= 0 && idx < data.length) {
                    final words = data[idx].label.split(' ');
                    final label = words.isNotEmpty ? words.first : '';
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final color = palette[idx % palette.length];
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: item.count.toDouble(),
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.65)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
