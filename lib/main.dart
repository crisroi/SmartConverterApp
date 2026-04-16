import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/currency_service.dart';
import 'providers/task_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final currencyService = CurrencyService();
  final taskProvider = TaskProvider();
  await currencyService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => currencyService,
        ),
        ChangeNotifierProvider(create: (_) => taskProvider)
      ],
      child: const SmartUtilityApp(),
    ),
  );
}
