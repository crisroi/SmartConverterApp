import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/length_units.dart';
import '../utils/length_converter.dart';
import '../widgets/converter_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/unit_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/length_units.dart';
import '../utils/length_converter.dart';
import '../widgets/converter_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/unit_dropdown.dart';

class LengthScreen extends StatefulWidget {
  const LengthScreen({super.key});

  @override
  State<LengthScreen> createState() => _LengthScreenState();
}

class _LengthScreenState extends State<LengthScreen> {
  static const Color _accent = Color(0xFFF5A623);

  LengthUnit _fromUnit = lengthUnits[0];
  LengthUnit _toUnit = lengthUnits[4];
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
    final result = LengthConverter.convert(amount, _fromUnit, _toUnit);
    setState(() => _resultValue = _format(result));
  }

  String _format(double value) {
    if (value == 0) return '0';
    if (value.abs() >= 1000000) return NumberFormat('#,##0.##').format(value);
    if (value.abs() >= 0.001) return NumberFormat('#,##0.########').format(value);
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
                title: 'Length',
                subtitle: 'Distance & dimension conversion',
                icon: Icons.straighten_rounded,
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
                fromDropdown: UnitDropdown<LengthUnit>(
                  value: _fromUnit,
                  items: lengthUnits,
                  labelBuilder: (u) => '${u.name} (${u.symbol})',
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _fromUnit = val);
                      _convert();
                    }
                  },
                  accentColor: _accent,
                ),
                toDropdown: UnitDropdown<LengthUnit>(
                  value: _toUnit,
                  items: lengthUnits,
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
              _LengthReferences(
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

class _LengthReferences extends StatelessWidget {
  final Color accent;
  final void Function(LengthUnit, LengthUnit, String) onTap;

  const _LengthReferences({required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final m = lengthUnits[0];
    final km = lengthUnits[1];
    final cm = lengthUnits[2];
    final mi = lengthUnits[4];
    final ft = lengthUnits[6];
    final inch = lengthUnits[7];

    final refs = [
      _Ref('1 m → ft', m, ft, '1'),
      _Ref('1 km → mi', km, mi, '1'),
      _Ref('1 mi → km', mi, km, '1'),
      _Ref('1 ft → cm', ft, cm, '1'),
      _Ref('100 m → ft', m, ft, '100'),
      _Ref('1 in → cm', inch, cm, '1'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: refs.map((r) {
          final result = LengthConverter.convert(
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
    if (v.abs() >= 0.001) return NumberFormat('#,##0.######').format(v);
    return v.toStringAsExponential(4);
  }
}

class _Ref {
  final String label;
  final LengthUnit from;
  final LengthUnit to;
  final String inputValue;
  const _Ref(this.label, this.from, this.to, this.inputValue);
}
