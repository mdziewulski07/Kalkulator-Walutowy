import 'dart:async';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../application/chart_range.dart';
import 'datasources/ecb_api.dart';
import 'datasources/local_hive.dart';
import 'datasources/local_sqlite.dart';
import 'datasources/nbp_api.dart';
import 'models/models.dart';

class CurrencyRepository {
  CurrencyRepository({
    required NbpApiClient nbpApi,
    required EcbApiClient ecbApi,
    required HiveCurrencyCache hiveCache,
    required SqliteSeriesStore sqliteStore,
    required Connectivity connectivity,
  })  : _nbpApi = nbpApi,
        _ecbApi = ecbApi,
        _hiveCache = hiveCache,
        _sqliteStore = sqliteStore,
        _connectivity = connectivity;

  final NbpApiClient _nbpApi;
  final EcbApiClient _ecbApi;
  final HiveCurrencyCache _hiveCache;
  final SqliteSeriesStore _sqliteStore;
  final Connectivity _connectivity;

  static const _rateTtl = Duration(hours: 12);

  Future<bool> get isOffline async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.none;
  }

  Future<double> loadRate(CurrencyPair pair, DataSource source,
      {bool forceRefresh = false}) async {
    final cachedRate = _hiveCache.getCachedRate(pair);
    final cachedTime = _hiveCache.getRateTimestamp(pair);
    final isFresh = cachedTime != null &&
        DateTime.now().difference(cachedTime) < _rateTtl;

    if (!forceRefresh && cachedRate != null && isFresh) {
      return cachedRate;
    }

    if (await isOffline && cachedRate != null) {
      return cachedRate;
    }

    final rate = await _fetchRemoteRate(pair, source);
    await _hiveCache.saveRate(pair, rate, DateTime.now());
    return rate;
  }

  Future<List<RatePoint>> loadSeries(
    CurrencyPair pair,
    ChartRange range,
    DataSource source,
  ) async {
    final cached = await _sqliteStore.loadSeries(pair);
    final shouldFetch = cached.isEmpty ||
        (cached.lastOrNull?.time ?? DateTime(2000)).difference(DateTime.now()).abs() >
            const Duration(days: 1);

    if (!shouldFetch) {
      return _filterRange(cached, range);
    }

    if (await isOffline && cached.isNotEmpty) {
      return _filterRange(cached, range);
    }

    final now = DateTime.now();
    final start = now.subtract(range.duration);
    final remote = await _fetchRemoteSeries(pair, source, start, now);
    if (remote.isNotEmpty) {
      await _sqliteStore.saveSeries(pair, remote);
    }
    return _filterRange(remote.isNotEmpty ? remote : cached, range);
  }

  Future<double> _fetchRemoteRate(CurrencyPair pair, DataSource source) {
    switch (source) {
      case DataSource.nbp:
        return _nbpApi.fetchLatestRate(pair);
      case DataSource.ecb:
        return _fetchEcbRate(pair);
    }
  }

  Future<double> _fetchEcbRate(CurrencyPair pair) async {
    final now = DateTime.now();
    final series = await _ecbApi.fetchSeries(
      pair: pair,
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
    if (series.isEmpty) {
      throw Exception('ECB returned empty rates');
    }
    return series.last.value;
  }

  Future<List<RatePoint>> _fetchRemoteSeries(
    CurrencyPair pair,
    DataSource source,
    DateTime start,
    DateTime end,
  ) {
    switch (source) {
      case DataSource.nbp:
        return _nbpApi.fetchSeries(pair: pair, start: start, end: end);
      case DataSource.ecb:
        return _ecbApi.fetchSeries(pair: pair, start: start, end: end);
    }
  }

  List<RatePoint> _filterRange(List<RatePoint> series, ChartRange range) {
    final now = DateTime.now();
    final start = now.subtract(range.duration);
    return series.where((point) => !point.time.isBefore(start)).toList();
  }

  Future<ChartStats> computeStats(List<RatePoint> series) async {
    if (series.isEmpty) {
      return ChartStats.zero();
    }
    final sorted = List<RatePoint>.from(series)..sort((a, b) => a.time.compareTo(b.time));
    final first = sorted.first.value;
    final last = sorted.last.value;
    final high = sorted.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final low = sorted.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final avg = sorted.map((e) => e.value).average;
    final delta = first == 0 ? 0.0 : ((last - first) / first) * 100;
    return ChartStats(deltaPct: delta, high: high, low: low, avg: avg);
  }

  static Future<CurrencyRepository> initialize(
    Settings settings,
    HiveCurrencyCache hiveCache,
    Connectivity connectivity,
  ) async {
    final documents = await getApplicationDocumentsDirectory();
    final path = '${documents.path}/currency.db';
    final db = await openDatabase(path, version: 1,
        onCreate: (db, version) async => SqliteSeriesStore.ensureTables(db));
    await SqliteSeriesStore.ensureTables(db);
    return CurrencyRepository(
      nbpApi: NbpApiClient(),
      ecbApi: EcbApiClient(),
      hiveCache: hiveCache,
      sqliteStore: SqliteSeriesStore(db),
      connectivity: connectivity,
    );
  }
}
