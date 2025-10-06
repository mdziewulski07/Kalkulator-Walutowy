import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

import '../test_utils/fakes.dart';

void main() {
  test('Repository caches series and serves offline', () async {
    final FakeConnectivity connectivity = FakeConnectivity(ConnectivityResult.wifi);
    final FakeLocalSqlite sqlite = FakeLocalSqlite();
    final FakeLocalHive hive = FakeLocalHive();
    final List<RatePoint> series = <RatePoint>[
      RatePoint(time: DateTime(2024, 1, 1), value: 3.5),
      RatePoint(time: DateTime(2024, 1, 2), value: 3.6),
    ];
    final CurrencyRepository repository = CurrencyRepository(
      nbpApi: FakeNbpApi(<String, double>{'USD': 1, 'PLN': 4}, series),
      ecbApi: FakeEcbApi(series),
      localSqlite: sqlite,
      hiveCache: hive,
      connectivity: connectivity,
    );

    final CurrencyPair pair = const CurrencyPair(base: 'USD', quote: 'PLN');

    final List<RatePoint> online = await repository.historicalSeries(
      pair: pair,
      range: ChartRange.d1,
      preference: DataSourcePreference.nbp,
    );
    expect(online, isNotEmpty);
    expect(sqlite.storage, isNotEmpty);

    connectivity.result = ConnectivityResult.none;

    final List<RatePoint> offline = await repository.historicalSeries(
      pair: pair,
      range: ChartRange.d1,
      preference: DataSourcePreference.nbp,
    );
    expect(offline, isNotEmpty);
  });
}
