import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/user_settings.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

/// يدير حالة إعدادات المستخدم ويزامنها مع التخزين ونظام الإشعارات
class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService;

  late UserSettings _settings;
  UserSettings get settings => _settings;

  SettingsProvider(this._storageService, this._notificationService) {
    _settings = _storageService.loadSettings();
  }

  Locale get locale => Locale(_settings.languageCode);

  ThemeMode get themeMode =>
      _settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> _persist() async {
    await _storageService.saveSettings(_settings);
    await _notificationService.scheduleReminders(_settings);
    notifyListeners();
  }

  Future<void> updateDailyGoal(int goalMl) async {
    _settings = _settings.copyWith(dailyGoalMl: goalMl);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateReminderInterval(int minutes) async {
    _settings = _settings.copyWith(reminderIntervalMinutes: minutes);
    await _persist();
  }

  Future<void> toggleReminders(bool enabled) async {
    _settings = _settings.copyWith(remindersEnabled: enabled);
    await _persist();
  }

  Future<void> updateActiveHours({
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) async {
    _settings = _settings.copyWith(
      activeStartHour: startHour,
      activeStartMinute: startMinute,
      activeEndHour: endHour,
      activeEndMinute: endMinute,
    );
    await _persist();
  }

  Future<void> updateUnit(WaterUnit unit) async {
    _settings = _settings.copyWith(unit: unit);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateSound(NotificationSoundOption sound) async {
    _settings = _settings.copyWith(sound: sound);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    _settings = _settings.copyWith(isDarkMode: isDark);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateLanguage(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateCupSize(int cupSizeMl) async {
    _settings = _settings.copyWith(cupSizeMl: cupSizeMl);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }
}
