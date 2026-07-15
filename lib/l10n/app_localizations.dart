import 'package:flutter/material.dart';

/// نظام ترجمة مكتوب يدويًا (بدون الحاجة لأداة flutter gen-l10n)
/// يدعم العربية (ar) والإنجليزية (en). يمكن التوسّع بإضافة لغات جديدة
/// عبر إضافة Map جديدة في [_localizedValues] وإضافة كود اللغة في
/// [AppLocalizations.delegate.isSupported].
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<String> supportedLanguageCodes = ['ar', 'en'];

  Map<String, String> get _values =>
      _localizedValues[locale.languageCode] ?? _localizedValues['en']!;

  String get appTitle => _values['appTitle']!;
  String get home => _values['home']!;
  String get stats => _values['stats']!;
  String get settings => _values['settings']!;
  String get todayIntake => _values['todayIntake']!;
  String get drinkCount => _values['drinkCount']!;
  String get nextReminder => _values['nextReminder']!;
  String get drankWaterButton => _values['drankWaterButton']!;
  String get remaining => _values['remaining']!;
  String get reminderSettings => _values['reminderSettings']!;
  String get enableReminders => _values['enableReminders']!;
  String get reminderInterval => _values['reminderInterval']!;
  String get activeHours => _values['activeHours']!;
  String get from => _values['from']!;
  String get to => _values['to']!;
  String get weeklyChart => _values['weeklyChart']!;
  String get goalAchievedDays => _values['goalAchievedDays']!;
  String get dailyGoal => _values['dailyGoal']!;
  String get measurementUnit => _values['measurementUnit']!;
  String get notificationSound => _values['notificationSound']!;
  String get darkMode => _values['darkMode']!;
  String get language => _values['language']!;
  String get milliliters => _values['milliliters']!;
  String get liters => _values['liters']!;
  String get cups => _values['cups']!;
  String get minutes => _values['minutes']!;
  String get hours => _values['hours']!;
  String get mins => _values['mins']!;
  String get cancel => _values['cancel']!;
  String get save => _values['save']!;
  String get arabic => _values['arabic']!;
  String get english => _values['english']!;
  String get default_ => _values['default_']!;
  String get chime => _values['chime']!;
  String get drop => _values['drop']!;
  String get bell => _values['bell']!;
  String get greatJob => _values['greatJob']!;
  String get resetToday => _values['resetToday']!;
  String get confirmReset => _values['confirmReset']!;
  String get achieved => _values['achieved']!;
  String get mon => _values['mon']!;
  String get tue => _values['tue']!;
  String get wed => _values['wed']!;
  String get thu => _values['thu']!;
  String get fri => _values['fri']!;
  String get sat => _values['sat']!;
  String get sun => _values['sun']!;

  String goalOf(String goal) => locale.languageCode == 'ar'
      ? 'من $goal'
      : 'of $goal goal';

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Hydro Reminder',
      'home': 'Home',
      'stats': 'Statistics',
      'settings': 'Settings',
      'todayIntake': "Today's Intake",
      'drinkCount': 'Drinks Today',
      'nextReminder': 'Next Reminder In',
      'drankWaterButton': 'I Drank Water',
      'remaining': 'remaining',
      'reminderSettings': 'Reminder Settings',
      'enableReminders': 'Enable Reminders',
      'reminderInterval': 'Reminder Interval',
      'activeHours': 'Active Hours',
      'from': 'From',
      'to': 'To',
      'weeklyChart': 'Weekly Chart',
      'goalAchievedDays': 'Days Goal Achieved',
      'dailyGoal': 'Daily Goal',
      'measurementUnit': 'Measurement Unit',
      'notificationSound': 'Notification Sound',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'milliliters': 'Milliliters (ml)',
      'liters': 'Liters (L)',
      'cups': 'Cups',
      'minutes': 'minutes',
      'hours': 'h',
      'mins': 'm',
      'cancel': 'Cancel',
      'save': 'Save',
      'arabic': 'العربية',
      'english': 'English',
      'default_': 'Default',
      'chime': 'Chime',
      'drop': 'Water Drop',
      'bell': 'Bell',
      'greatJob': 'Great job! Keep drinking water 💧',
      'resetToday': "Reset Today's Data",
      'confirmReset': 'Are you sure you want to reset today\'s data?',
      'achieved': 'Goal Achieved!',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
    },
    'ar': {
      'appTitle': 'تذكير الماء',
      'home': 'الرئيسية',
      'stats': 'الإحصائيات',
      'settings': 'الإعدادات',
      'todayIntake': 'كمية الماء اليوم',
      'drinkCount': 'مرات الشرب اليوم',
      'nextReminder': 'التذكير القادم خلال',
      'drankWaterButton': 'شربت الماء',
      'remaining': 'المتبقي',
      'reminderSettings': 'إعدادات التذكير',
      'enableReminders': 'تفعيل التذكيرات',
      'reminderInterval': 'مدة التذكير',
      'activeHours': 'ساعات التنشيط',
      'from': 'من',
      'to': 'إلى',
      'weeklyChart': 'الرسم البياني الأسبوعي',
      'goalAchievedDays': 'عدد أيام تحقيق الهدف',
      'dailyGoal': 'الهدف اليومي',
      'measurementUnit': 'وحدة القياس',
      'notificationSound': 'صوت الإشعار',
      'darkMode': 'الوضع الليلي',
      'language': 'اللغة',
      'milliliters': 'ملليلتر (مل)',
      'liters': 'لتر',
      'cups': 'أكواب',
      'minutes': 'دقيقة',
      'hours': 'س',
      'mins': 'د',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'arabic': 'العربية',
      'english': 'English',
      'default_': 'افتراضي',
      'chime': 'جرس',
      'drop': 'قطرة ماء',
      'bell': 'ناقوس',
      'greatJob': 'أحسنت! واصل شرب الماء 💧',
      'resetToday': 'إعادة تعيين بيانات اليوم',
      'confirmReset': 'هل أنت متأكد من إعادة تعيين بيانات اليوم؟',
      'achieved': 'تم تحقيق الهدف!',
      'mon': 'إثن',
      'tue': 'ثلا',
      'wed': 'أرب',
      'thu': 'خمي',
      'fri': 'جمع',
      'sat': 'سبت',
      'sun': 'أحد',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
