import 'package:flutter/material.dart';
import '../models/water_entry.dart';
import '../services/storage_service.dart';
import 'settings_provider.dart';

/// يدير حالة تسجيلات شرب الماء والإحصائيات المرتبطة بها
class WaterProvider extends ChangeNotifier {
  final StorageService _storageService;
  final SettingsProvider _settingsProvider;

  List<WaterEntry> _entries = [];
  List<WaterEntry> get allEntries => _entries;

  WaterProvider(this._storageService, this._settingsProvider) {
    _entries = _storageService.getAllEntries();
  }

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  List<WaterEntry> get todayEntries =>
      _entries.where((e) => e.dayKey == _todayKey).toList();

  int get todayTotalMl =>
      todayEntries.fold(0, (sum, e) => sum + e.amountMl);

  int get todayDrinkCount => todayEntries.length;

  int get dailyGoalMl => _settingsProvider.settings.dailyGoalMl;

  double get progressRatio =>
      dailyGoalMl == 0 ? 0 : (todayTotalMl / dailyGoalMl).clamp(0, 1);

  bool get goalAchievedToday => todayTotalMl >= dailyGoalMl;

  /// إضافة كوب ماء جديد بالحجم الافتراضي المحدد في الإعدادات
  Future<void> addCup() async {
    final cupSize = _settingsProvider.settings.cupSizeMl;
    final entry = WaterEntry(
      id: _storageService.generateNextId(),
      amountMl: cupSize,
      timestamp: DateTime.now(),
    );
    await _storageService.addEntry(entry);
    _entries = _storageService.getAllEntries();
    notifyListeners();
  }

  Future<void> removeEntry(int id) async {
    await _storageService.deleteEntry(id);
    _entries = _storageService.getAllEntries();
    notifyListeners();
  }

  Future<void> resetToday() async {
    await _storageService.clearEntriesForDay(_todayKey);
    _entries = _storageService.getAllEntries();
    notifyListeners();
  }

  /// إجمالي الماء لكل يوم خلال آخر 7 أيام (للرسم البياني الأسبوعي)
  /// المفتاح هو تاريخ اليوم، والقيمة هي الكمية بالملليلتر
  Map<DateTime, int> lastSevenDaysTotals() {
    final now = DateTime.now();
    final Map<DateTime, int> result = {};

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      result[day] = 0;
    }

    for (final entry in _entries) {
      final day = DateTime(
          entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      if (result.containsKey(day)) {
        result[day] = (result[day] ?? 0) + entry.amountMl;
      }
    }
    return result;
  }

  /// عدد الأيام (من كل السجل) التي تحقق فيها الهدف اليومي
  int get goalAchievedDaysCount {
    final Map<String, int> dailyTotals = {};
    for (final entry in _entries) {
      dailyTotals[entry.dayKey] =
          (dailyTotals[entry.dayKey] ?? 0) + entry.amountMl;
    }
    return dailyTotals.values.where((total) => total >= dailyGoalMl).length;
  }
}
