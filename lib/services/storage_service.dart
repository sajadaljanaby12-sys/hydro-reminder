import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/user_settings.dart';
import '../models/water_entry.dart';

/// طبقة الوصول للبيانات المحلية (Hive)
/// مسؤولة فقط عن القراءة والكتابة، بدون منطق أعمال
class StorageService {
  late Box<WaterEntry> _entriesBox;
  late Box _settingsBox;

  /// تهيئة Hive وفتح الصناديق - يجب استدعاؤها قبل استخدام أي دالة أخرى
  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WaterEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }

    _entriesBox =
        await Hive.openBox<WaterEntry>(AppConstants.waterEntriesBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
  }

  // ------------------ الإعدادات ------------------

  UserSettings loadSettings() {
    final raw = _settingsBox.get(AppConstants.settingsKey);
    if (raw == null) return const UserSettings();
    return raw as UserSettings;
  }

  Future<void> saveSettings(UserSettings settings) async {
    await _settingsBox.put(AppConstants.settingsKey, settings);
  }

  // ------------------ تسجيلات الماء ------------------

  List<WaterEntry> getAllEntries() {
    return _entriesBox.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> addEntry(WaterEntry entry) async {
    await _entriesBox.put(entry.id, entry);
  }

  Future<void> deleteEntry(int id) async {
    await _entriesBox.delete(id);
  }

  /// حذف كل تسجيلات يوم معين (لإعادة التعيين)
  Future<void> clearEntriesForDay(String dayKey) async {
    final idsToDelete = _entriesBox.values
        .where((e) => e.dayKey == dayKey)
        .map((e) => e.id)
        .toList();
    for (final id in idsToDelete) {
      await _entriesBox.delete(id);
    }
  }

  int generateNextId() {
    if (_entriesBox.isEmpty) return 1;
    return _entriesBox.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
