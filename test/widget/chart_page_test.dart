import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kalkulator_walutowy/features/currency/application/chart_controller.dart';
import 'package:kalkulator_walutowy/features/currency/application/settings_controller.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/rates_chart_page.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../test_utils/fakes.dart';

void main() {
  testWidgets('Rates chart page shows line chart', (WidgetTester tester) async {
    final SettingsController settingsController = SettingsController(initial: Settings.defaults());
    final CurrencyRepository repository = CurrencyRepository(
      nbpApi: FakeNbpApi(
        <String, double>{'USD': 1, 'PLN': 4},
        <RatePoint>[
          RatePoint(time: DateTime.now().subtract(const Duration(days: 1)), value: 3.5),
          RatePoint(time: DateTime.now(), value: 3.7),
        ],
      ),
      ecbApi: FakeEcbApi(<RatePoint>[]),
      localSqlite: FakeLocalSqlite(),
      hiveCache: FakeLocalHive(),
      connectivity: FakeConnectivity(<ConnectivityResult>[ConnectivityResult.wifi]),
    );
    final ChartController chartController = ChartController(repository, settingsController);
    await chartController.load();

    await tester.pumpWidget(
      MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<SettingsController>.value(value: settingsController),
          ChangeNotifierProvider<ChartController>.value(value: chartController),
        ],
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RatesChartPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(LineChart), findsOneWidget);
  });
}
