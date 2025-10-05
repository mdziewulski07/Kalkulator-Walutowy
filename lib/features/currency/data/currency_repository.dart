import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../currency/data/datasources/ecb_api.dart';
import '../../currency/data/datasources/local_hive.dart';
import '../../currency/data/datasources/local_sqlite.dart';
import '../../currency/data/datasources/nbp_api.dart';
import 'models.dart';

class CurrencyRepository {
  CurrencyRepository({
    required Dio dio,
    required Connectivity connectivity,
    required SharedPreferences prefs,
    required Box<dynamic> hiveBox,
    required Database database,
  })  : _dio = dio,
        _connectivity = connectivity,
        _prefs = prefs,
        _hiveCache = HiveCache(hiveBox),
        _chartDb = ChartDatabase(database),
        _nbpApi = NbpApi(dio),
        _ecbApi = EcbApi(dio);

  final Dio _dio;
  final Connectivity _connectivity;
  final SharedPreferences _prefs;
  final HiveCache _hiveCache;
  final ChartDatabase _chartDb;
  final NbpApi _nbpApi;
  final EcbApi _ecbApi;

  static const _ttlKey = 'ttl';

  Future<double> convert({
    required CurrencyPair pair,
    required double amount,
    required DataSourceType source,
  }) async {
    final rate = await _getRate(pair: pair, source: source);
    return amount * rate;
  }

  Future<double> _getRate({
    required CurrencyPair pair,
    required DataSourceType source,
  }) async {
    final cached = _hiveCache.getRate(pair);
    final updated = _hiveCache.getUpdatedAt(pair);
    final ttl = Duration(hours: _prefs.getInt(_ttlKey) ?? 12);
    if (cached != null && updated != null && DateTime.now().difference(updated) < ttl) {
      return cached;
    }

    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity == ConnectivityResult.none && cached != null) {
      return cached;
    }

    double freshRate;
    if (source == DataSourceType.nbp) {
      freshRate = await _nbpApi.fetchLatestRate(pair);
    } else {
      final latest = await _ecbApi.fetchLatestRates();
      if (pair.base == 'EUR') {
        freshRate = 1 / (latest[pair.quote] ?? 1);
      } else if (pair.quote == 'EUR') {
        freshRate = latest[pair.base] ?? 1;
      } else {
        final base = latest[pair.base] ?? 1;
        final quote = latest[pair.quote] ?? 1;
        freshRate = (quote / base);
      }
    }

    await _hiveCache.saveRate(pair, freshRate);
    return freshRate;
  }

  Future<List<RatePoint>> loadChart({
    required CurrencyPair pair,
    required Duration range,
    required DataSourceType source,
  }) async {
    final since = DateTime.now().subtract(range);
    final cached = await _chartDb.loadPoints(pair, since);
    if (cached.isNotEmpty) {
      return cached;
    }

    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return cached;
    }

    List<RatePoint> fresh;
    if (source == DataSourceType.nbp) {
      fresh = await _nbpApi.fetchSeries(pair, start: since);
    } else {
      fresh = await _ecbApi.fetchSeries(pair.base, start: since);
      if (pair.quote != 'EUR') {
        final quoteSeries = await _ecbApi.fetchSeries(pair.quote, start: since);
        final quoteMap = {for (final point in quoteSeries) point.time: point.value};
        fresh = fresh
            .where((point) => quoteMap.containsKey(point.time))
            .map((point) => RatePoint(
                  time: point.time,
                  value: quoteMap[point.time]! / point.value,
                ))
            .toList();
      }
    }

    await _chartDb.savePoints(pair, fresh);
    return fresh;
  }

  ChartStats computeStats(List<RatePoint> points) {
    if (points.isEmpty) {
      return const ChartStats(deltaPct: 0, high: 0, low: 0, avg: 0);
    }
    final values = points.map((e) => e.value).toList();
    final start = values.first;
    final end = values.last;
    final delta = start == 0 ? 0 : ((end - start) / start) * 100;
    final high = values.reduce(max);
    final low = values.reduce(min);
    final avg = values.reduce((a, b) => a + b) / values.length;
    return ChartStats(deltaPct: delta, high: high, low: low, avg: avg);
  }

  Future<Settings> loadSettings() async {
    final themeIndex = _prefs.getInt('theme') ?? 0;
    final dataSource = DataSourceType.values[_prefs.getInt('source') ?? 0];
    return Settings(
      defaultCurrency: _prefs.getString('defaultCurrency') ?? Settings.defaults().defaultCurrency,
      decimals: _prefs.getInt('decimals') ?? Settings.defaults().decimals,
      themeMode: ThemeSetting.values[themeIndex],
      dataSource: dataSource,
      flagsEnabled: _prefs.getBool('flags') ?? true,
      hapticsEnabled: _prefs.getBool('haptics') ?? true,
      numberFormat: _prefs.getString('numberFormat') ?? 'comma',
      rateAlerts: _prefs.getBool('alerts') ?? false,
      analyticsEnabled: _prefs.getBool('analytics') ?? false,
    );
  }

  Future<void> saveSettings(Settings settings) async {
    await _prefs.setString('defaultCurrency', settings.defaultCurrency);
    await _prefs.setInt('decimals', settings.decimals);
    await _prefs.setInt('theme', settings.themeMode.index);
    await _prefs.setInt('source', settings.dataSource.index);
    await _prefs.setBool('flags', settings.flagsEnabled);
    await _prefs.setBool('haptics', settings.hapticsEnabled);
    await _prefs.setString('numberFormat', settings.numberFormat);
    await _prefs.setBool('alerts', settings.rateAlerts);
    await _prefs.setBool('analytics', settings.analyticsEnabled);
  }

  Future<void> resetData() async {
    await _prefs.clear();
    await _hiveCache.box.clear();
  }

  static Future<CurrencyRepository> create() async {
    final connectivity = Connectivity();
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
    final prefs = await SharedPreferences.getInstance();
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    final box = await Hive.openBox('currency');
    final path = '${dir.path}/currency.db';
    final db = await openDatabase(path, version: 1, onCreate: ChartDatabase.migrate, onUpgrade: ChartDatabase.migrate);

    return CurrencyRepository(
      dio: dio,
      connectivity: connectivity,
      prefs: prefs,
      hiveBox: box,
      database: db,
    );
  }
}
