import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants/weight_units.dart';
import '../../utils/weight_converter.dart';
import '../../widgets/converter_card.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/unit_dropdown.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  static const Color _accent = Color(0xFF6C63FF);

  WeightUnit _fromUnit = weightUnits[0];
  WeightUnit _toUnit = weightUnits[4];
  String _inputValue = '';
  String _resultValue = '';

  void _convert() {
    if (_inputValue.isEmpty) {
      setState(() => _resultValue = '');
      return;
    }
    final amount = double.tryParse(_inputValue);
    if (amount == null) {
      setState(() => _resultValue = '');
      return;
    }
    final result = WeightConverter.convert(amount, _fromUnit, _toUnit);
    setState(() => _resultValue = _format(result));
  }

  String _format(double value) {
    if (value == 0) return '0';
    if (value.abs() >= 1000000) return NumberFormat('#,##0.##').format(value);
    if (value.abs() >= 0.01) return NumberFormat('#,##0.######').format(value);
    return value.toStringAsExponential(4);
  }

  void _swap() {
    setState(() {
      final tmp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = tmp;
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: 'Weight',
                subtitle: 'Mass & weight conversion',
                icon: Icons.fitness_center_rounded,
                accentColor: _accent,
              ),

              ConverterCard(
                inputValue: _inputValue,
                resultValue: _resultValue,
                fromLabel: _fromUnit.symbol,
                toLabel: _toUnit.symbol,
                accentColor: _accent,
                onInputChanged: (val) {
                  setState(() => _inputValue = val);
                  _convert();
                },
                onSwap: _swap,
                fromDropdown: UnitDropdown<WeightUnit>(
                  value: _fromUnit,
                  items: weightUnits,
                  labelBuilder: (u) => '${u.name} (${u.symbol})',
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _fromUnit = val);
                      _convert();
                    }
                  },
                  accentColor: _accent,
                ),
                toDropdown: UnitDropdown<WeightUnit>(
                  value: _toUnit,
                  items: weightUnits,
                  labelBuilder: (u) => '${u.name} (${u.symbol})',
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _toUnit = val);
                      _convert();
                    }
                  },
                  accentColor: _accent,
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Common references',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _WeightReferences(
                accent: _accent,
                onTap: (from, to, value) {
                  setState(() {
                    _fromUnit = from;
                    _toUnit = to;
                    _inputValue = value;
                  });
                  _convert();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightReferences extends StatelessWidget {
  final Color accent;
  final void Function(WeightUnit, WeightUnit, String) onTap;

  const _WeightReferences({required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final kg = weightUnits[0];
    final g = weightUnits[1];
    final lb = weightUnits[4];
    final oz = weightUnits[5];
    final st = weightUnits[6];

    final refs = [
      _Ref('1 kg → lb', kg, lb, '1'),
      _Ref('1 lb → kg', lb, kg, '1'),
      _Ref('1 oz → g', oz, g, '1'),
      _Ref('70 kg → lb', kg, lb, '70'),
      _Ref('100 lb → kg', lb, kg, '100'),
      _Ref('1 st → kg', st, kg, '1'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: refs.map((r) {
          final result = WeightConverter.convert(
            double.parse(r.inputValue),
            r.from,
            r.to,
          );
          return GestureDetector(
            onTap: () => onTap(r.from, r.to, r.inputValue),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_fmt(result)} ${r.to.symbol}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _fmt(double v) {
    if (v.abs() >= 100) return NumberFormat('#,##0.##').format(v);
    return NumberFormat('#,##0.####').format(v);
  }
}

class _Ref {
  final String label;
  final WeightUnit from;
  final WeightUnit to;
  final String inputValue;
  const _Ref(this.label, this.from, this.to, this.inputValue);
}
