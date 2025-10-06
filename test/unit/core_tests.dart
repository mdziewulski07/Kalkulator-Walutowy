import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kalkulator_walutowy/features/currency/application/calculator_controller.dart';
import 'package:kalkulator_walutowy/features/currency/application/settings_controller.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

import '../test_utils/fakes.dart';

void main() {
  group('Parsing', () {
    test('NBP series parsing', () {
      const String json = '{"rates":[{"effectiveDate":"2024-01-01","mid":3.5}]}';
      final List<RatePoint> points = NbpApi.parseSeries(json);
      expect(points, hasLength(1));
      expect(points.first.value, 3.5);
    });

    test('Chart stats computed', () {
      final List<RatePoint> points = <RatePoint>[
        RatePoint(time: DateTime(2024, 1, 1), value: 3.0),
        RatePoint(time: DateTime(2024, 1, 2), value: 4.0),
      ];
      final ChartStats stats = ChartStats.fromPoints(points);
      expect(stats.high, 4.0);
      expect(stats.low, 3.0);
      expect(stats.deltaPct, closeTo(33.33, 0.1));
    });
  });

  group('Conversion', () {
    late CurrencyRepository repository;
    late SettingsController settingsController;
    late CalculatorController calculatorController;

    setUp(() async {
      final FakeLocalSqlite sqlite = FakeLocalSqlite();
      final FakeLocalHive hive = FakeLocalHive();
      repository = CurrencyRepository(
        nbpApi: FakeNbpApi(<String, double>{'USD': 1, 'PLN': 4.0}, <RatePoint>[]),
        ecbApi: FakeEcbApi(<RatePoint>[]),
        localSqlite: sqlite,
        hiveCache: hive,
        connectivity: FakeConnectivity(<ConnectivityResult>[ConnectivityResult.wifi]),
      );
      settingsController = SettingsController(initial: Settings.defaults());
      calculatorController = CalculatorController(repository, settingsController);
      calculatorController.setLocale('en');
      await calculatorController.load();
    });

    test('Base to quote conversion', () {
      expect(calculatorController.formattedQuote(), isNotEmpty);
      expect(calculatorController.state.rate, 4.0);
    });
  });
}
