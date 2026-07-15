import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/unit_formatter.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/water_provider.dart';
import '../services/notification_service.dart';
import '../widgets/drink_button.dart';
import '../widgets/stat_card.dart';
import '../widgets/water_progress_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _ticker;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final settingsProvider = context.read<SettingsProvider>();
    final notificationService = context.read<NotificationService>();
    final remaining =
        notificationService.timeUntilNextReminder(settingsProvider.settings);
    if (mounted) {
      setState(() => _remaining = remaining);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d, AppLocalizations l10n) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours${l10n.hours} $minutes${l10n.mins}';
    }
    return '$minutes${l10n.mins}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final waterProvider = context.watch<WaterProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final unit = settingsProvider.settings.unit;
    final cupSize = settingsProvider.settings.cupSizeMl;

    final totalFormatted =
        UnitFormatter.format(waterProvider.todayTotalMl, unit, cupSizeMl: cupSize);
    final goalFormatted =
        UnitFormatter.format(waterProvider.dailyGoalMl, unit, cupSizeMl: cupSize);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              if (waterProvider.goalAchievedToday)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(l10n.achieved,
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              WaterProgressWidget(
                progress: waterProvider.progressRatio,
                centerLabel: totalFormatted,
                subLabel: l10n.goalOf(goalFormatted),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.local_drink_outlined,
                      label: l10n.drinkCount,
                      value: '${waterProvider.todayDrinkCount}',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: StatCard(
                      icon: Icons.timer_outlined,
                      label: l10n.nextReminder,
                      value: _remaining == null
                          ? '--'
                          : _formatDuration(_remaining!, l10n),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              DrinkButton(
                label: l10n.drankWaterButton,
                onPressed: () async {
                  await context.read<WaterProvider>().addCup();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.greatJob),
                        backgroundColor: AppTheme.primaryBlue,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
