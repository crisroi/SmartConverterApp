class LengthUnit {
  final String name;
  final String symbol;
  final double toMeters;

  const LengthUnit({
    required this.name,
    required this.symbol,
    required this.toMeters,
  });
}

const List<LengthUnit> lengthUnits = [
  LengthUnit(name: 'Meter',       symbol: 'm',  toMeters: 1.0),
  LengthUnit(name: 'Kilometer',   symbol: 'km', toMeters: 1000.0),
  LengthUnit(name: 'Centimeter',  symbol: 'cm', toMeters: 0.01),
  LengthUnit(name: 'Millimeter',  symbol: 'mm', toMeters: 0.001),
  LengthUnit(name: 'Mile',        symbol: 'mi', toMeters: 1609.344),
  LengthUnit(name: 'Yard',        symbol: 'yd', toMeters: 0.9144),
  LengthUnit(name: 'Foot',        symbol: 'ft', toMeters: 0.3048),
  LengthUnit(name: 'Inch',        symbol: 'in', toMeters: 0.0254),
  LengthUnit(name: 'Nautical Mile', symbol: 'nmi', toMeters: 1852.0),
  LengthUnit(name: 'Light Year',  symbol: 'ly', toMeters: 9.461e15),
];
