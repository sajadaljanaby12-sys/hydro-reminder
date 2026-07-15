import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import '../core/constants/app_constants.dart';
import '../models/user_settings.dart';

/// خدمة إدارة الإشعارات المحلية الدورية لتذكير المستخدم بشرب الماء
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// تهيئة المكتبة والمنطقة الزمنية - تُستدعى مرة واحدة عند بدء التطبيق
  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    try {
      final String localTz = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(localTz));
    } catch (_) {
      // في حال تعذر تحديد المنطقة الزمنية المحلية بدقة، استخدم UTC كافتراضي آمن
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // إنشاء قناة الإشعارات على أندرويد
    const channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  /// طلب أذونات الإشعارات (مطلوب على iOS و Android 13+)
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// إلغاء جميع التذكيرات المجدولة
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// إعادة جدولة جميع التذكيرات بناءً على الإعدادات الحالية.
  /// يجدول إشعارات لبقية اليوم الحالي ضمن نافذة الساعات النشطة،
  /// وإن انتهت ساعات اليوم يبدأ الجدولة من بداية الغد.
  Future<void> scheduleReminders(UserSettings settings) async {
    await cancelAll();
    if (!settings.remindersEnabled) return;

    final now = tz.TZDateTime.now(tz.local);
    final interval = Duration(minutes: settings.reminderIntervalMinutes);

    // ابنِ نافذة اليوم الحالي [بداية النشاط - نهاية النشاط]
    tz.TZDateTime windowStart = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.activeStartHour,
      settings.activeStartMinute,
    );
    tz.TZDateTime windowEnd = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.activeEndHour,
      settings.activeEndMinute,
    );

    // إن كان الوقت الحالي بعد نهاية نافذة اليوم، انتقل مباشرة لغد
    if (now.isAfter(windowEnd)) {
      windowStart = windowStart.add(const Duration(days: 1));
      windowEnd = windowEnd.add(const Duration(days: 1));
    }

    // أول وقت تذكير هو أقرب وقت بعد الآن (أو بداية النافذة إن لم تبدأ بعد)
    tz.TZDateTime nextTime = now.isBefore(windowStart) ? windowStart : now.add(interval);

    int notificationId = 0;
    const maxNotifications = 60; // حد أعلى أمان لتفادي جدولة عدد ضخم دفعة واحدة

    while (notificationId < maxNotifications) {
      if (nextTime.isAfter(windowEnd)) {
        // انتقل لليوم التالي وابدأ من جديد
        windowStart = tz.TZDateTime(
          tz.local,
          windowStart.year,
          windowStart.month,
          windowStart.day + 1,
          settings.activeStartHour,
          settings.activeStartMinute,
        );
        windowEnd = tz.TZDateTime(
          tz.local,
          windowEnd.year,
          windowEnd.month,
          windowEnd.day + 1,
          settings.activeEndHour,
          settings.activeEndMinute,
        );
        nextTime = windowStart;
      }

      await _scheduleOne(notificationId, nextTime);
      notificationId++;
      nextTime = nextTime.add(interval);

      // نكتفي بجدولة يوم ونصف تقريبًا مسبقًا؛ يعاد الجدولة تلقائيًا
      // عند فتح التطبيق أو تغيير الإعدادات لضمان استمرارية التذكيرات
      if (notificationId >= 24) break;
    }
  }

  Future<void> _scheduleOne(int id, tz.TZDateTime time) async {
    await _plugin.zonedSchedule(
      id,
      '💧 حان وقت شرب الماء!',
      'تذكير: اشرب كوبًا من الماء الآن للحفاظ على ترطيب جسمك',
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// يحسب الوقت المتبقي حتى أقرب تذكير قادم (لعرضه في الشاشة الرئيسية)
  Duration? timeUntilNextReminder(UserSettings settings) {
    if (!settings.remindersEnabled) return null;

    final now = DateTime.now();
    final interval = Duration(minutes: settings.reminderIntervalMinutes);

    DateTime windowStart = DateTime(
      now.year,
      now.month,
      now.day,
      settings.activeStartHour,
      settings.activeStartMinute,
    );
    DateTime windowEnd = DateTime(
      now.year,
      now.month,
      now.day,
      settings.activeEndHour,
      settings.activeEndMinute,
    );

    if (now.isBefore(windowStart)) {
      return windowStart.difference(now);
    }
    if (now.isAfter(windowEnd)) {
      final tomorrowStart = windowStart.add(const Duration(days: 1));
      return tomorrowStart.difference(now);
    }

    final next = now.add(interval);
    if (next.isAfter(windowEnd)) {
      final tomorrowStart = windowStart.add(const Duration(days: 1));
      return tomorrowStart.difference(now);
    }
    return interval;
  }
}
