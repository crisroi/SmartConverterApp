import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/currency_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final currencyService = CurrencyService();
  await currencyService.init();

  runApp(
    ChangeNotifierProvider.value(
      value: currencyService,
      child: const SmartUtilityApp(),
    ),
  );
}