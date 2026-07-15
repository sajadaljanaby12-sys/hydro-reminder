import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/unit_formatter.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/water_provider.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  List<String> _weekdayLabels(AppLocalizations l10n) => [
        l10n.mon,
        l10n.tue,
        l10n.wed,
        l10n.thu,
        l10n.fri,
        l10n.sat,
        l10n.sun,
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final waterProvider = context.watch<WaterProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final unit = settingsProvider.settings.unit;
    final cupSize = settingsProvider.settings.cupSizeMl;

    final weekTotals = waterProvider.lastSevenDaysTotals();
    final maxVal = weekTotals.values.isEmpty
        ? 1000.0
        : (weekTotals.values.reduce((a, b) => a > b ? a : b))
            .toDouble()
            .clamp(500, double.infinity);

    final labels = _weekdayLabels(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stats)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.water_drop_outlined,
                    label: l10n.todayIntake,
                    value: UnitFormatter.format(
                        waterProvider.todayTotalMl, unit,
                        cupSizeMl: cupSize),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: StatCard(
                    icon: Icons.emoji_events_outlined,
                    label: l10n.goalAchievedDays,
                    value: '${waterProvider.goalAchievedDaysCount}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.weeklyChart,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 260,
              padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BarChart(
                BarChartData(
                  maxY: maxVal * 1.2,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[index],
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < weekTotals.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: weekTotals.values.elementAt(i).toDouble(),
                            width: 22,
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppTheme.primaryBlue, AppTheme.lightBlue],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
