import '../constants/length_units.dart';

class LengthConverter {
  /// Convert [value] from [from] unit to [to] unit.
  /// Uses base-unit (meters) as intermediate.
  static double convert(double value, LengthUnit from, LengthUnit to) {
    if (from.symbol == to.symbol) return value;
    final inMeters = value * from.toMeters;
    return inMeters / to.toMeters;
  }
}
