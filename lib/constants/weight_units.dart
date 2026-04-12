class WeightUnit {
  final String name;
  final String symbol;
  final double toKg;

  const WeightUnit({
    required this.name,
    required this.symbol,
    required this.toKg,
  });
}

const List<WeightUnit> weightUnits = [
  WeightUnit(name: 'Kilogram',  symbol: 'kg',  toKg: 1.0),
  WeightUnit(name: 'Gram',      symbol: 'g',   toKg: 0.001),
  WeightUnit(name: 'Milligram', symbol: 'mg',  toKg: 0.000001),
  WeightUnit(name: 'Metric Ton',symbol: 't',   toKg: 1000.0),
  WeightUnit(name: 'Pound',     symbol: 'lb',  toKg: 0.45359237),
  WeightUnit(name: 'Ounce',     symbol: 'oz',  toKg: 0.028349523125),
  WeightUnit(name: 'Stone',     symbol: 'st',  toKg: 6.35029318),
  WeightUnit(name: 'US Ton',    symbol: 'ton', toKg: 907.18474),
];
