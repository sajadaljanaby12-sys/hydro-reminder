/// ثوابت التطبيق العامة
class AppConstants {
  AppConstants._();

  // أسماء صناديق Hive
  static const String settingsBoxName = 'settings_box';
  static const String waterEntriesBoxName = 'water_entries_box';

  // مفاتيح التخزين
  static const String settingsKey = 'user_settings';

  // القيم الافتراضية
  static const int defaultGoalMl = 2000;
  static const int defaultIntervalMinutes = 90;
  static const int defaultCupSizeMl = 250;
  static const int defaultStartHour = 8;
  static const int defaultStartMinute = 0;
  static const int defaultEndHour = 22;
  static const int defaultEndMinute = 0;

  // خيارات مدة التذكير المتاحة (بالدقائق)
  static const List<int> intervalOptions = [30, 60, 90, 120];

  // معرف قناة الإشعارات
  static const String notificationChannelId = 'hydro_reminder_channel';
  static const String notificationChannelName = 'Hydro Reminder';
  static const String notificationChannelDescription =
      'تذكيرات دورية لشرب الماء';
}

/// وحدات قياس الماء المدعومة
enum WaterUnit { ml, liter, cup }

/// أصوات الإشعار المتاحة
enum NotificationSoundOption { default_, chime, drop, bell }
