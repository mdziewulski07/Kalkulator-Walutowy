import 'package:kalkulator_walutowy/features/currency/data/datasources/ecb_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_sqlite.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FakeConnectivity implements ConnectivityProbe {
  FakeConnectivity(this.results);

  List<ConnectivityResult> results;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => results;
}

class FakeNbpApi extends NbpApi {
  FakeNbpApi(this.latest, this.series);

  final Map<String, double> latest;
  final List<RatePoint> series;

  @override
  Future<Map<String, double>> fetchLatestRates(String table) async => latest;

  @override
  Future<List<RatePoint>> fetchSeries({
    required CurrencyPair pair,
    required DateTime start,
    required DateTime end,
  }) async => series;
}

class FakeEcbApi extends EcbApi {
  FakeEcbApi(this.series);

  final List<RatePoint> series;

  @override
  Future<List<RatePoint>> fetchSeries({
    required CurrencyPair pair,
    required DateTime start,
    required DateTime end,
  }) async => series;
}

class FakeLocalSqlite extends LocalSqliteBase {
  final Map<String, List<RatePoint>> storage = <String, List<RatePoint>>{};

  @override
  Future<void> cacheSeries(CurrencyPair pair, List<RatePoint> points) async {
    storage['${pair.base}-${pair.quote}'] = points;
  }

  @override
  Future<List<RatePoint>> loadSeries(CurrencyPair pair, DateTime start) async {
    return storage['${pair.base}-${pair.quote}'] ?? <RatePoint>[];
  }
}

class FakeLocalHive extends LocalHiveCacheBase {
  Map<String, double> latest = <String, double>{};

  @override
  Future<Map<String, double>> readRates() async => latest;

  @override
  Future<Map<String, dynamic>> readMeta() async => <String, dynamic>{};

  @override
  Future<void> saveLatestRates(
    Map<String, double> rates,
    DateTime timestamp,
    DataSourcePreference source,
  ) async {
    latest = rates;
  }
}
