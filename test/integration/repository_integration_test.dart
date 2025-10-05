import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/ecb_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_sqlite.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class FakeNbpApi extends NbpApi {
  FakeNbpApi();
  @override
  Future<double> fetchRate(CurrencyPair pair) async => 4.2;

  @override
  Future<List<RatePoint>> fetchSeries(CurrencyPair pair, DateTime start, DateTime end) async {
    return [
      RatePoint(timestamp: start, value: 4.0),
      RatePoint(timestamp: end, value: 4.2),
    ];
  }
}

class FakeEcbApi extends EcbApi {
  FakeEcbApi();
  @override
  Future<List<RatePoint>> fetchSeries(CurrencyPair pair) async {
    return [
      RatePoint(timestamp: DateTime.now().subtract(const Duration(days: 1)), value: 4.0),
      RatePoint(timestamp: DateTime.now(), value: 4.1),
    ];
  }
}

class FakeLocalSqlite extends LocalSqliteDataSource {
  final Map<String, List<RatePoint>> _storage = {};

  @override
  Future<void> storeSeries(CurrencyPair pair, List<RatePoint> points) async {
    _storage['${pair.base}_${pair.quote}'] = points;
  }

  @override
  Future<List<RatePoint>> readSeries(CurrencyPair pair) async {
    return _storage['${pair.base}_${pair.quote}'] ?? [];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Hive.init(Directory.systemTemp.createTempSync().path);

  test('Repository computes stats and caches rate', () async {
    final repository = CurrencyRepository(
      nbpApi: FakeNbpApi(),
      ecbApi: FakeEcbApi(),
      hive: LocalHiveDataSource(),
      sqlite: FakeLocalSqlite(),
    );
    final pair = CurrencyPair(base: 'USD', quote: 'PLN');
    final rate = await repository.fetchRate(pair, DataSourcePreference.nbp);
    expect(rate, 4.2);
    final stats = repository.computeStats([
      RatePoint(timestamp: DateTime.now().subtract(const Duration(days: 1)), value: 4.0),
      RatePoint(timestamp: DateTime.now(), value: 4.2),
    ]);
    expect(stats.deltaPct, closeTo(5.0, 0.0001));
  });
}
