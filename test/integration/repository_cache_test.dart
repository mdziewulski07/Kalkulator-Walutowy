import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/ecb_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_sqlite.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models/models.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class _MockNbpApi extends Mock implements NbpApiClient {}

class _MockEcbApi extends Mock implements EcbApiClient {}

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database db;
  late HiveCurrencyCache hiveCache;
  late CurrencyRepository repository;
  late _MockNbpApi nbpApi;
  late _MockEcbApi ecbApi;
  late _MockConnectivity connectivity;

  setUpAll(() {
    Hive.init('.');
  });

  setUp(() async {
    final databasePath = await getDatabasesPath();
    db = await openDatabase(p.join(databasePath, 'test_cache.db'), version: 1,
        onCreate: (db, version) async => SqliteSeriesStore.ensureTables(db));
    await SqliteSeriesStore.ensureTables(db);
    hiveCache = HiveCurrencyCache(await Hive.openBox('test_box'));
    nbpApi = _MockNbpApi();
    ecbApi = _MockEcbApi();
    connectivity = _MockConnectivity();
    repository = CurrencyRepository(
      nbpApi: nbpApi,
      ecbApi: ecbApi,
      hiveCache: hiveCache,
      sqliteStore: SqliteSeriesStore(db),
      connectivity: connectivity,
    );
  });

  tearDown(() async {
    await db.close();
    if (Hive.isBoxOpen('test_box')) {
      await Hive.box('test_box').close();
    }
    await Hive.deleteBoxFromDisk('test_box');
  });

  test('uses cache when offline', () async {
    final pair = const CurrencyPair(base: 'USD', quote: 'PLN');
    when(() => connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    when(() => nbpApi.fetchLatestRate(pair)).thenAnswer((_) async => 4.0);
    final rate = await repository.loadRate(pair, DataSource.nbp, forceRefresh: true);
    expect(rate, 4.0);

    when(() => connectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);
    when(() => nbpApi.fetchLatestRate(pair)).thenThrow(Exception('network'));
    final cached = await repository.loadRate(pair, DataSource.nbp);
    expect(cached, 4.0);
  });
}
