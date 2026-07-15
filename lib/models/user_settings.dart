import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

/// يمثل جميع إعدادات المستخدم القابلة للتخصيص
class UserSettings {
  final int dailyGoalMl;
  final int reminderIntervalMinutes;
  final bool remindersEnabled;
  final int activeStartHour;
  final int activeStartMinute;
  final int activeEndHour;
  final int activeEndMinute;
  final WaterUnit unit;
  final NotificationSoundOption sound;
  final bool isDarkMode;
  final String languageCode; // 'ar' or 'en'
  final int cupSizeMl;

  const UserSettings({
    this.dailyGoalMl = AppConstants.defaultGoalMl,
    this.reminderIntervalMinutes = AppConstants.defaultIntervalMinutes,
    this.remindersEnabled = true,
    this.activeStartHour = AppConstants.defaultStartHour,
    this.activeStartMinute = AppConstants.defaultStartMinute,
    this.activeEndHour = AppConstants.defaultEndHour,
    this.activeEndMinute = AppConstants.defaultEndMinute,
    this.unit = WaterUnit.ml,
    this.sound = NotificationSoundOption.default_,
    this.isDarkMode = false,
    this.languageCode = 'ar',
    this.cupSizeMl = AppConstants.defaultCupSizeMl,
  });

  UserSettings copyWith({
    int? dailyGoalMl,
    int? reminderIntervalMinutes,
    bool? remindersEnabled,
    int? activeStartHour,
    int? activeStartMinute,
    int? activeEndHour,
    int? activeEndMinute,
    WaterUnit? unit,
    NotificationSoundOption? sound,
    bool? isDarkMode,
    String? languageCode,
    int? cupSizeMl,
  }) {
    return UserSettings(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      activeStartHour: activeStartHour ?? this.activeStartHour,
      activeStartMinute: activeStartMinute ?? this.activeStartMinute,
      activeEndHour: activeEndHour ?? this.activeEndHour,
      activeEndMinute: activeEndMinute ?? this.activeEndMinute,
      unit: unit ?? this.unit,
      sound: sound ?? this.sound,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      cupSizeMl: cupSizeMl ?? this.cupSizeMl,
    );
  }

  Map<String, dynamic> toMap() => {
        'dailyGoalMl': dailyGoalMl,
        'reminderIntervalMinutes': reminderIntervalMinutes,
        'remindersEnabled': remindersEnabled,
        'activeStartHour': activeStartHour,
        'activeStartMinute': activeStartMinute,
        'activeEndHour': activeEndHour,
        'activeEndMinute': activeEndMinute,
        'unit': unit.index,
        'sound': sound.index,
        'isDarkMode': isDarkMode,
        'languageCode': languageCode,
        'cupSizeMl': cupSizeMl,
      };

  factory UserSettings.fromMap(Map<dynamic, dynamic> map) => UserSettings(
        dailyGoalMl: map['dailyGoalMl'] as int? ?? AppConstants.defaultGoalMl,
        reminderIntervalMinutes: map['reminderIntervalMinutes'] as int? ??
            AppConstants.defaultIntervalMinutes,
        remindersEnabled: map['remindersEnabled'] as bool? ?? true,
        activeStartHour: map['activeStartHour'] as int? ??
            AppConstants.defaultStartHour,
        activeStartMinute: map['activeStartMinute'] as int? ??
            AppConstants.defaultStartMinute,
        activeEndHour:
            map['activeEndHour'] as int? ?? AppConstants.defaultEndHour,
        activeEndMinute:
            map['activeEndMinute'] as int? ?? AppConstants.defaultEndMinute,
        unit: WaterUnit.values[map['unit'] as int? ?? 0],
        sound: NotificationSoundOption
            .values[map['sound'] as int? ?? 0],
        isDarkMode: map['isDarkMode'] as bool? ?? false,
        languageCode: map['languageCode'] as String? ?? 'ar',
        cupSizeMl: map['cupSizeMl'] as int? ?? AppConstants.defaultCupSizeMl,
      );
}

/// محول Hive يدوي لإعدادات المستخدم
class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 2;

  @override
  UserSettings read(BinaryReader reader) {
    final map = reader.readMap();
    return UserSettings.fromMap(map);
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer.writeMap(obj.toMap());
  }
}
