import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/currency_service.dart';
import '../widgets/converter_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/unit_dropdown.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  static const Color _accent = Color(0xFF00D9A3);

  String _fromCurrency = 'USD';
  String _toCurrency = 'NGN';
  String _inputValue = '';
  String _resultValue = '';

  void _convert(CurrencyService service) {
    if (_inputValue.isEmpty || !service.hasRates) {
      setState(() => _resultValue = '');
      return;
    }
    final amount = double.tryParse(_inputValue);
    if (amount == null) {
      setState(() => _resultValue = '');
      return;
    }
    final result =
        service.rates!.convert(amount, _fromCurrency, _toCurrency);
    setState(() {
      _resultValue = _formatResult(result);
    });
  }

  String _formatResult(double value) {
    if (value == 0) return '0';
    if (value >= 1000000) {
      return NumberFormat('#,##0.00').format(value);
    }
    if (value >= 1) {
      return NumberFormat('#,##0.####').format(value);
    }
    return NumberFormat('#,##0.########').format(value);
  }

  void _swap() {
    setState(() {
      final tmp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<CurrencyService>();
    final currencies = service.availableCurrencies;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: 'Currency',
                subtitle: 'Live exchange rates',
                icon: Icons.currency_exchange_rounded,
                accentColor: _accent,
                actions: [
                  IconButton(
                    icon: service.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _accent,
                            ),
                          )
                        : Icon(Icons.refresh_rounded,
                            color: _accent.withOpacity(0.7), size: 22),
                    onPressed:
                        service.isLoading ? null : service.fetchRates,
                  ),
                ],
              ),

              // Status bar
              if (service.error != null)
                _StatusBanner(
                  message: service.error!,
                  isError: true,
                  accent: _accent,
                )
              else if (service.hasRates)
                _StatusBanner(
                  message:
                      'Rates updated ${_timeAgo(service.rates!.fetchedAt)}',
                  isError: false,
                  accent: _accent,
                ),

              const SizedBox(height: 8),

              ConverterCard(
                inputValue: _inputValue,
                resultValue: _resultValue,
                fromLabel: _fromCurrency,
                toLabel: _toCurrency,
                accentColor: _accent,
                onInputChanged: (val) {
                  setState(() => _inputValue = val);
                  _convert(service);
                },
                onSwap: () {
                  _swap();
                  _convert(service);
                },
                fromDropdown: service.isLoading && !service.hasRates
                    ? _LoadingDropdown(accent: _accent)
                    : UnitDropdown<String>(
                        value: _fromCurrency,
                        items: currencies,
                        labelBuilder: (c) => '$c — ${_currencyName(c)}',
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _fromCurrency = val);
                            _convert(service);
                          }
                        },
                        accentColor: _accent,
                      ),
                toDropdown: service.isLoading && !service.hasRates
                    ? _LoadingDropdown(accent: _accent)
                    : UnitDropdown<String>(
                        value: _toCurrency,
                        items: currencies,
                        labelBuilder: (c) => '$c — ${_currencyName(c)}',
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _toCurrency = val);
                            _convert(service);
                          }
                        },
                        accentColor: _accent,
                      ),
              ),

              const SizedBox(height: 28),

              if (service.hasRates) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Quick reference  ·  1 $_fromCurrency',
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
                _QuickRatesGrid(
                  fromCurrency: _fromCurrency,
                  service: service,
                  accent: _accent,
                  onTap: (currency) {
                    setState(() => _toCurrency = currency);
                    _convert(service);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _currencyName(String code) {
    const names = {
      'USD': 'US Dollar', 'EUR': 'Euro', 'GBP': 'British Pound',
      'JPY': 'Japanese Yen', 'NGN': 'Nigerian Naira',
      'CAD': 'Canadian Dollar', 'AUD': 'Australian Dollar',
      'CHF': 'Swiss Franc', 'CNY': 'Chinese Yuan',
      'INR': 'Indian Rupee', 'BRL': 'Brazilian Real',
      'MXN': 'Mexican Peso', 'KES': 'Kenyan Shilling',
      'ZAR': 'South African Rand', 'GHS': 'Ghanaian Cedi',
      'AED': 'UAE Dirham', 'SAR': 'Saudi Riyal',
      'SGD': 'Singapore Dollar', 'HKD': 'Hong Kong Dollar',
      'NOK': 'Norwegian Krone', 'SEK': 'Swedish Krona',
      'DKK': 'Danish Krone', 'NZD': 'New Zealand Dollar',
      'TRY': 'Turkish Lira', 'RUB': 'Russian Ruble',
      'PKR': 'Pakistani Rupee', 'EGP': 'Egyptian Pound',
      'THB': 'Thai Baht', 'IDR': 'Indonesian Rupiah',
      'MYR': 'Malaysian Ringgit', 'PHP': 'Philippine Peso',
    };
    return names[code] ?? code;
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;
  final Color accent;

  const _StatusBanner({
    required this.message,
    required this.isError,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = isError ? const Color(0xFFFF6B6B) : accent;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.dmSans(fontSize: 12, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDropdown extends StatelessWidget {
  final Color accent;
  const _LoadingDropdown({required this.accent});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: accent),
        ),
      ),
    );
  }
}

class _QuickRatesGrid extends StatelessWidget {
  final String fromCurrency;
  final CurrencyService service;
  final Color accent;
  final void Function(String) onTap;

  const _QuickRatesGrid({
    required this.fromCurrency,
    required this.service,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const quick = ['USD', 'EUR', 'GBP', 'NGN', 'JPY', 'CAD'];
    final show = quick.where((c) => c != fromCurrency).take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: show.map((currency) {
          final rate = service.rates!.convert(1, fromCurrency, currency);
          return GestureDetector(
            onTap: () => onTap(currency),
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
                    currency,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _fmt(rate),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
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
    if (v >= 1000) return NumberFormat('#,##0.##').format(v);
    if (v >= 1) return NumberFormat('#,##0.####').format(v);
    return NumberFormat('0.######').format(v);
  }
}
