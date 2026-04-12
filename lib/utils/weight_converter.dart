import '../constants/weight_units.dart';

class WeightConverter {
  /// Convert [value] from [from] unit to [to] unit.
  /// Uses base-unit (kg) as intermediate.
  static double convert(double value, WeightUnit from, WeightUnit to) {
    if (from.symbol == to.symbol) return value;
    final inKg = value * from.toKg;
    return inKg / to.toKg;
  }
}
