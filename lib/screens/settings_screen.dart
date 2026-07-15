import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/water_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle(title: l10n.reminderSettings),
            _CardContainer(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.enableReminders),
                    value: settings.remindersEnabled,
                    onChanged: (val) =>
                        settingsProvider.toggleReminders(val),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l10n.reminderInterval),
                    trailing: DropdownButton<int>(
                      value: settings.reminderIntervalMinutes,
                      underline: const SizedBox(),
                      items: AppConstants.intervalOptions
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text('$m ${l10n.minutes}'),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          settingsProvider.updateReminderInterval(val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l10n.activeHours),
                    subtitle: Text(
                      '${l10n.from} ${_fmtTime(settings.activeStartHour, settings.activeStartMinute)}   '
                      '${l10n.to} ${_fmtTime(settings.activeEndHour, settings.activeEndMinute)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showActiveHoursSheet(context, settingsProvider),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: l10n.dailyGoal),
            _CardContainer(
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.dailyGoal),
                    trailing: DropdownButton<int>(
                      value: settings.dailyGoalMl,
                      underline: const SizedBox(),
                      items: const [1500, 2000, 2500, 3000, 3500]
                          .map((v) => DropdownMenuItem(
                                value: v,
                                child: Text('${(v / 1000).toStringAsFixed(1)} L'),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          settingsProvider.updateDailyGoal(val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l10n.measurementUnit),
                    trailing: DropdownButton<WaterUnit>(
                      value: settings.unit,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                            value: WaterUnit.ml, child: Text(l10n.milliliters)),
                        DropdownMenuItem(
                            value: WaterUnit.liter, child: Text(l10n.liters)),
                        DropdownMenuItem(
                            value: WaterUnit.cup, child: Text(l10n.cups)),
                      ],
                      onChanged: (val) {
                        if (val != null) settingsProvider.updateUnit(val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: l10n.settings),
            _CardContainer(
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.notificationSound),
                    trailing: DropdownButton<NotificationSoundOption>(
                      value: settings.sound,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                            value: NotificationSoundOption.default_,
                            child: Text(l10n.default_)),
                        DropdownMenuItem(
                            value: NotificationSoundOption.chime,
                            child: Text(l10n.chime)),
                        DropdownMenuItem(
                            value: NotificationSoundOption.drop,
                            child: Text(l10n.drop)),
                        DropdownMenuItem(
                            value: NotificationSoundOption.bell,
                            child: Text(l10n.bell)),
                      ],
                      onChanged: (val) {
                        if (val != null) settingsProvider.updateSound(val);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.darkMode),
                    value: settings.isDarkMode,
                    onChanged: (val) => settingsProvider.toggleDarkMode(val),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l10n.language),
                    trailing: DropdownButton<String>(
                      value: settings.languageCode,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
                        DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                      ],
                      onChanged: (val) {
                        if (val != null) settingsProvider.updateLanguage(val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _CardContainer(
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: Text(l10n.resetToday,
                    style: const TextStyle(color: Colors.redAccent)),
                onTap: () => _confirmReset(context, l10n),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _fmtTime(int h, int m) {
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    return '$hour12:${m.toString().padLeft(2, '0')} $period';
  }

  void _confirmReset(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetToday),
        content: Text(l10n.confirmReset),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ctx.read<WaterProvider>().resetToday();
              Navigator.pop(ctx);
            },
            child: Text(l10n.save, style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showActiveHoursSheet(
      BuildContext context, SettingsProvider settingsProvider) {
    final l10n = AppLocalizations.of(context)!;
    final settings = settingsProvider.settings;
    TimeOfDay start =
        TimeOfDay(hour: settings.activeStartHour, minute: settings.activeStartMinute);
    TimeOfDay end =
        TimeOfDay(hour: settings.activeEndHour, minute: settings.activeEndMinute);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.activeHours,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(l10n.from),
                    trailing: Text(_fmtTime(start.hour, start.minute)),
                    onTap: () async {
                      final picked =
                          await showTimePicker(context: ctx, initialTime: start);
                      if (picked != null) setState(() => start = picked);
                    },
                  ),
                  ListTile(
                    title: Text(l10n.to),
                    trailing: Text(_fmtTime(end.hour, end.minute)),
                    onTap: () async {
                      final picked =
                          await showTimePicker(context: ctx, initialTime: end);
                      if (picked != null) setState(() => end = picked);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        settingsProvider.updateActiveHours(
                          startHour: start.hour,
                          startMinute: start.minute,
                          endHour: end.hour,
                          endMinute: end.minute,
                        );
                        Navigator.pop(ctx);
                      },
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 6, left: 6),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
