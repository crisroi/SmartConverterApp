class ExchangeRateModel {
  final String base;
  final Map<String, double> rates;
  final DateTime fetchedAt;

  ExchangeRateModel({
    required this.base,
    required this.rates,
    required this.fetchedAt,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final ratesMap = <String, double>{};
    final rawRates = json['rates'] as Map<String, dynamic>;
    rawRates.forEach((key, value) {
      ratesMap[key] = (value as num).toDouble();
    });
    return ExchangeRateModel(
      base: json['base_code'] as String? ?? 'USD',
      rates: ratesMap,
      fetchedAt: DateTime.now(),
    );
  }

  /// Convert [amount] from [fromCurrency] to [toCurrency].
  double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    double inBase;
    if (fromCurrency == base) {
      inBase = amount;
    } else {
      final fromRate = rates[fromCurrency];
      if (fromRate == null || fromRate == 0) return 0;
      inBase = amount / fromRate;
    }

    if (toCurrency == base) return inBase;

    final toRate = rates[toCurrency];
    if (toRate == null) return 0;
    return inBase * toRate;
  }

  bool get isStale =>
      DateTime.now().difference(fetchedAt).inHours >= 12;
}
