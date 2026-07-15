# 💧 Hydro Reminder

تطبيق جوال (Android / iOS) مبني بـ **Flutter** لمساعدتك على شرب الماء بانتظام
عبر إشعارات محلية دورية.

## المميزات
- شاشة رئيسية تعرض الكمية المستهلكة، عدد الأكواب، والوقت المتبقي للتذكير القادم.
- زر "شربت الماء" لتسجيل كوب جديد بضغطة واحدة.
- تذكيرات محلية قابلة للتخصيص (المدة، ساعات التفعيل، التشغيل/الإيقاف).
- إحصائيات يومية وأسبوعية (رسم بياني) وعدد أيام تحقيق الهدف.
- إعدادات: الهدف اليومي، وحدة القياس (مل/لتر/كوب)، صوت الإشعار، الوضع الليلي، اللغة (عربي/إنجليزي).
- تخزين محلي بالكامل عبر **Hive** — بدون حساب أو إنترنت.

## التقنيات المستخدمة
| التقنية | الاستخدام |
|---|---|
| Flutter / Dart | بناء الواجهة والمنطق |
| Provider | إدارة الحالة |
| Hive | تخزين محلي (Settings + WaterEntry) |
| flutter_local_notifications + timezone | التذكيرات المجدولة |
| fl_chart | الرسم البياني الأسبوعي |
| flutter_localizations + ARB | دعم العربية والإنجليزية |

## هيكل المشروع
```
lib/
 ├─ core/
 │   ├─ constants/      # ثوابت التطبيق ومنسق الوحدات
 │   └─ theme/          # الثيم الفاتح والداكن
 ├─ l10n/               # ملفات الترجمة (ARB) + الملف المولّد
 ├─ models/             # WaterEntry, UserSettings + Hive Adapters يدوية
 ├─ services/            # StorageService (Hive), NotificationService
 ├─ providers/           # WaterProvider, SettingsProvider (ChangeNotifier)
 ├─ screens/             # Home, Stats, Settings, MainNavigation
 ├─ widgets/             # WaterProgressWidget, DrinkButton, StatCard
 └─ main.dart
```

تم اختيار **محولات Hive يدوية** (بدون `build_runner`/codegen) حتى يعمل المشروع
مباشرة دون خطوة توليد كود إضافية.

## خطوات التشغيل

### المتطلبات
- Flutter SDK (channel stable, الإصدار 3.19 أو أحدث) مثبت على جهازك.
- Android Studio أو VS Code مع أدوات Flutter/Dart.
- محاكي Android أو جهاز iOS/Android حقيقي.

### 1) تثبيت الحزم
```bash
flutter pub get
```

### 2) توليد ملفات الترجمة (تُولَّد تلقائيًا مع flutter pub get بسبب `generate: true`)
إن لم تتولد تلقائيًا نفّذ:
```bash
flutter gen-l10n
```

### 3) التشغيل
```bash
flutter run
```

### 4) بناء نسخة الإصدار
```bash
# Android
flutter build apk --release
# أو App Bundle لمتجر Google Play
flutter build appbundle --release

# iOS (على Mac فقط، يتطلب Xcode)
flutter build ios --release
```

## ملاحظات مهمة قبل النشر
1. **أيقونة التطبيق**: تم توليد أيقونة مبدئية بسيطة (قطرة ماء زرقاء) في
   `android/app/src/main/res/mipmap-*/ic_launcher.png`. يُنصح باستبدالها بأيقونة
   احترافية باستخدام حزمة `flutter_launcher_icons`.
2. **iOS**: تم تجهيز هذا المشروع بمجلد `android/` جاهز فقط. لإضافة دعم iOS
   نفّذ الأمر التالي مرة واحدة في جذر المشروع (على جهاز Mac مع Xcode مثبت)،
   وسيقوم Flutter بتوليد مجلد `ios/` كاملًا (Podfile، Info.plist، إلخ) بما
   يتوافق مع إصدار Flutter لديك دون المساس بملفات `lib/`:
   ```bash
   flutter create --platforms=ios .
   ```
   بعدها افتح `ios/Runner.xcworkspace` في Xcode لضبط `Bundle Identifier` و`Signing`.
3. **صوت الإشعار المخصص**: خيار "صوت الإشعار" في الإعدادات جاهز في الواجهة؛
   لتفعيل أصوات مخصصة فعليًا، أضف ملفات `.mp3`/`.caf` إلى `assets/sounds/`،
   فعّل قسم `assets` في `pubspec.yaml`، واربط اسم الصوت بمعامل `sound` في
   `AndroidNotificationDetails` / `DarwinNotificationDetails` داخل
   `notification_service.dart`.
4. **الأذونات على Android 13+**: التطبيق يطلب إذن `POST_NOTIFICATIONS` تلقائيًا
   عند أول تشغيل.
5. **دقة الجدولة على iOS**: نظام iOS يحد عدد الإشعارات المجدولة مسبقًا (~64)،
   لذا تتم جدولة تذكيرات يوم واحد فقط مقدمًا ويُعاد جدولتها تلقائيًا عند فتح
   التطبيق أو تغيير الإعدادات لضمان الاستمرارية.

## الترخيص
مشروع مفتوح للتخصيص والاستخدام الحر ضمن احتياجاتك.
