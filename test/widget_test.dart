import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kalkulator_walutowy/features/currency/application/calculator_controller.dart';
import 'package:kalkulator_walutowy/features/currency/application/settings_controller.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/calculator_page.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'test_utils/fakes.dart';

void main() {
  testWidgets('calculator page boots with providers', (WidgetTester tester) async {
    final SettingsController settingsController = SettingsController(initial: Settings.defaults());
    final CurrencyRepository repository = CurrencyRepository(
      nbpApi: FakeNbpApi(<String, double>{'USD': 1, 'PLN': 4.0}, <RatePoint>[]),
      ecbApi: FakeEcbApi(<RatePoint>[]),
      localSqlite: FakeLocalSqlite(),
      hiveCache: FakeLocalHive(),
      connectivity: FakeConnectivity(<ConnectivityResult>[ConnectivityResult.wifi]),
    );
    final CalculatorController calculatorController = CalculatorController(repository, settingsController);
    await calculatorController.load();

    await tester.pumpWidget(
      MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<SettingsController>.value(value: settingsController),
          ChangeNotifierProvider<CalculatorController>.value(value: calculatorController),
        ],
        child: const _CalculatorTestApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('PLN'), findsWidgets);
  });
}

class _CalculatorTestApp extends StatelessWidget {
  const _CalculatorTestApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CalculatorPage(),
    );
  }
}
