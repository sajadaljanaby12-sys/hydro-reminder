import 'package:hive/hive.dart';

/// يمثل تسجيلة واحدة لكوب ماء تم شربه
class WaterEntry {
  final int id;
  final int amountMl;
  final DateTime timestamp;

  WaterEntry({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  /// مفتاح اليوم بصيغة yyyy-MM-dd لتجميع البيانات اليومية
  String get dayKey =>
      '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toMap() => {
        'id': id,
        'amountMl': amountMl,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WaterEntry.fromMap(Map<String, dynamic> map) => WaterEntry(
        id: map['id'] as int,
        amountMl: map['amountMl'] as int,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
}

/// محول Hive يدوي (بدون الحاجة لـ build_runner)
class WaterEntryAdapter extends TypeAdapter<WaterEntry> {
  @override
  final int typeId = 1;

  @override
  WaterEntry read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return WaterEntry.fromMap(map);
  }

  @override
  void write(BinaryWriter writer, WaterEntry obj) {
    writer.writeMap(obj.toMap());
  }
}
