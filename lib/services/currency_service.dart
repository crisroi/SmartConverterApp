import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rate_model.dart';

class CurrencyService extends ChangeNotifier {
  static const String _cacheKey = 'exchange_rates_cache';
  static const String _cacheTimeKey = 'exchange_rates_time';
  static const String _apiUrl =
      'https://open.exchangerate-api.com/v6/latest/USD';

  ExchangeRateModel? _rates;
  bool _isLoading = false;
  String? _error;

  ExchangeRateModel? get rates => _rates;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasRates => _rates != null;

  static const List<String> popularCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'NGN',
    'CAD', 'AUD', 'CHF', 'CNY', 'INR',
    'BRL', 'MXN', 'KES', 'ZAR', 'GHS',
    'AED', 'SAR', 'SGD', 'HKD', 'NOK',
  ];

  Future<void> init() async {
    await _loadFromCache();
    if (_rates == null || _rates!.isStale) {
      await fetchRates();
    }
  }

  Future<void> fetchRates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        _rates = ExchangeRateModel.fromJson(json);
        await _saveToCache(response.body);
        _error = null;
      } else {
        _error = 'Failed to fetch rates (${response.statusCode})';
      }
    } catch (e) {
      _error = 'Network error. Showing cached rates.';
      _rates ??= _fallbackRates();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ExchangeRateModel _fallbackRates() {
    return ExchangeRateModel(
      base: 'USD',
      fetchedAt: DateTime.now(),
      rates: {
        'USD': 1.0,
        'EUR': 0.92,
        'GBP': 0.79,
        'NGN': 1601.0,
        'JPY': 149.5,
        'CAD': 1.36,
        'AUD': 1.53,
        'CHF': 0.90,
        'CNY': 7.24,
        'INR': 83.1,
        'BRL': 4.97,
        'MXN': 17.2,
        'KES': 129.5,
        'ZAR': 18.6,
        'GHS': 12.1,
        'AED': 3.67,
        'SAR': 3.75,
        'SGD': 1.34,
        'HKD': 7.82,
        'NOK': 10.6,
      },
    );
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      final timeStr = prefs.getString(_cacheTimeKey);

      if (cached != null) {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        _rates = ExchangeRateModel.fromJson(json);

        if (timeStr != null) {
          final fetchTime = DateTime.tryParse(timeStr);
          if (fetchTime != null) {
            _rates = ExchangeRateModel(
              base: _rates!.base,
              rates: _rates!.rates,
              fetchedAt: fetchTime,
            );
          }
        }
      }
    } catch (_) {
      _rates = _fallbackRates();
    }
  }

  Future<void> _saveToCache(String rawJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, rawJson);
      await prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
    } catch (_) {}
  }

  List<String> get availableCurrencies {
    if (_rates == null) return popularCurrencies;
    final all = _rates!.rates.keys.toList()..sort();
    final popular = popularCurrencies.where(all.contains).toList();
    final rest = all.where((c) => !popularCurrencies.contains(c)).toList();
    return [...popular, ...rest];
  }
}
