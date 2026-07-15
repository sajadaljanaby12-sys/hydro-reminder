import 'app_constants.dart';

/// دوال مساعدة لتحويل وعرض كميات الماء حسب وحدة القياس المختارة
class UnitFormatter {
  UnitFormatter._();

  static String format(int amountMl, WaterUnit unit, {int cupSizeMl = 250}) {
    switch (unit) {
      case WaterUnit.ml:
        return '$amountMl mL';
      case WaterUnit.liter:
        final liters = amountMl / 1000;
        return '${liters.toStringAsFixed(2)} L';
      case WaterUnit.cup:
        final cups = amountMl / cupSizeMl;
        return '${cups.toStringAsFixed(1)}';
    }
  }

  static String unitSuffix(WaterUnit unit) {
    switch (unit) {
      case WaterUnit.ml:
        return 'mL';
      case WaterUnit.liter:
        return 'L';
      case WaterUnit.cup:
        return 'cup';
    }
  }
}
