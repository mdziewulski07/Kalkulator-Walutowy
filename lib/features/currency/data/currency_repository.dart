import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'datasources/ecb_api.dart';
import 'datasources/local_hive.dart';
import 'datasources/local_sqlite.dart';
import 'datasources/nbp_api.dart';
import 'models.dart';

abstract class ConnectivityProbe {
  Future<List<ConnectivityResult>> checkConnectivity();
}

class ConnectivityPlusProbe implements ConnectivityProbe {
  ConnectivityPlusProbe([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() => _connectivity.checkConnectivity();
}

class CurrencyRepository {
  CurrencyRepository({
    required NbpApi nbpApi,
    required EcbApi ecbApi,
    required LocalSqliteBase localSqlite,
    required LocalHiveCacheBase hiveCache,
    ConnectivityProbe? connectivity,
  })  : _nbpApi = nbpApi,
        _ecbApi = ecbApi,
        _localSqlite = localSqlite,
        _hiveCache = hiveCache,
        _connectivity = connectivity ?? ConnectivityPlusProbe();

  final NbpApi _nbpApi;
  final EcbApi _ecbApi;
  final LocalSqliteBase _localSqlite;
  final LocalHiveCacheBase _hiveCache;
  final ConnectivityProbe _connectivity;

  Future<Map<String, double>> latestRates(DataSourcePreference preference) async {
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    final bool online = connectivityResult.any((ConnectivityResult result) => result != ConnectivityResult.none);
    if (online) {
      final Map<String, double> rates = await _nbpApi.fetchLatestRates(preference == DataSourcePreference.nbp ? 'A' : 'A');
      await _hiveCache.saveLatestRates(rates, DateTime.now(), preference);
      return rates;
    }
    return _hiveCache.readRates();
  }

  Future<double> conversionRate(CurrencyPair pair, DataSourcePreference preference) async {
    final Map<String, double> rates = await latestRates(preference);
    final double? baseRate = rates[pair.base];
    final double? quoteRate = rates[pair.quote];
    if (baseRate == null || quoteRate == null) {
      if (!rates.containsKey(pair.base) && pair.base == 'PLN') {
        return (quoteRate ?? 1).toDouble();
      }
      if (!rates.containsKey(pair.quote) && pair.quote == 'PLN') {
        return 1 / (baseRate ?? 1);
      }
      return 1;
    }
    return quoteRate / baseRate;
  }

  Future<List<RatePoint>> historicalSeries({
    required CurrencyPair pair,
    required ChartRange range,
    required DataSourcePreference preference,
  }) async {
    final DateTime end = DateTime.now();
    final DateTime start = end.subtract(range.duration);
    final List<ConnectivityResult> connectivity = await _connectivity.checkConnectivity();
    final bool online = connectivity.any((ConnectivityResult result) => result != ConnectivityResult.none);
    if (online) {
      final List<RatePoint> points;
      if (preference == DataSourcePreference.nbp) {
        points = await _nbpApi.fetchSeries(pair: pair, start: start, end: end);
      } else {
        points = await _ecbApi.fetchSeries(pair: pair, start: start, end: end);
      }
      await _localSqlite.cacheSeries(pair, points);
      return points;
    }
    final List<RatePoint> cached = await _localSqlite.loadSeries(pair, start);
    if (cached.isNotEmpty) {
      return cached;
    }
    return _syntheticFallback(start: start, end: end);
  }

  Future<ChartStats> statisticsForSeries(List<RatePoint> points) async {
    return compute<List<RatePoint>, ChartStats>(_calculateStats, points);
  }

  List<RatePoint> _syntheticFallback({required DateTime start, required DateTime end}) {
    final Random random = Random(42);
    final int days = end.difference(start).inDays.abs().clamp(1, 365);
    return List<RatePoint>.generate(days + 1, (int i) {
      final DateTime date = start.add(Duration(days: i));
      final double value = 3.2 + random.nextDouble() * 0.5 + i * 0.005;
      return RatePoint(time: date, value: value);
    });
  }
}

ChartStats _calculateStats(List<RatePoint> points) => ChartStats.fromPoints(points);
