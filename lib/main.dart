import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'providers/water_provider.dart';
import 'screens/main_navigation.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة خدمة التخزين المحلي أولاً
  final storageService = StorageService();
  await storageService.init();

  // تهيئة خدمة الإشعارات وطلب الأذونات
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  runApp(HydroReminderApp(
    storageService: storageService,
    notificationService: notificationService,
  ));
}

class HydroReminderApp extends StatelessWidget {
  final StorageService storageService;
  final NotificationService notificationService;

  const HydroReminderApp({
    super.key,
    required this.storageService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(storageService, notificationService),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, WaterProvider>(
          create: (ctx) => WaterProvider(
            storageService,
            ctx.read<SettingsProvider>(),
          ),
          update: (ctx, settingsProvider, previous) =>
              previous ?? WaterProvider(storageService, settingsProvider),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'Hydro Reminder',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,
            locale: settingsProvider.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const AppStartup(),
          );
        },
      ),
    );
  }
}

/// يضمن جدولة التذكيرات عند أول إقلاع للتطبيق بناءً على الإعدادات المحفوظة
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = context.read<SettingsProvider>();
      final notificationService = context.read<NotificationService>();
      notificationService.scheduleReminders(settingsProvider.settings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainNavigation();
  }
}
