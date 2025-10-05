import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/ecb_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_sqlite.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class CurrencyRepository {
  CurrencyRepository({
    required NbpApi nbpApi,
    required EcbApi ecbApi,
    required LocalHiveDataSource hive,
    required LocalSqliteDataSource sqlite,
  })  : _nbpApi = nbpApi,
        _ecbApi = ecbApi,
        _hive = hive,
        _sqlite = sqlite;

  final NbpApi _nbpApi;
  final EcbApi _ecbApi;
  final LocalHiveDataSource _hive;
  final LocalSqliteDataSource _sqlite;

  Future<double> fetchRate(CurrencyPair pair, DataSourcePreference source) async {
    final cached = await _hive.readCachedRate(pair);
    if (cached != null) {
      return cached;
    }
    double rate;
    if (source == DataSourcePreference.nbp) {
      rate = await _nbpApi.fetchRate(pair);
    } else {
      final series = await _ecbApi.fetchSeries(pair);
      if (series.isEmpty) {
        throw Exception('Empty ECB series');
      }
      rate = series.last.value;
      await _sqlite.storeSeries(pair, series);
    }
    await _hive.cacheRate(pair, rate, DateTime.now());
    return rate;
  }

  Future<List<RatePoint>> fetchSeries(
    CurrencyPair pair,
    DataSourcePreference source,
    DateTime start,
    DateTime end,
  ) async {
    try {
      if (source == DataSourcePreference.nbp) {
        final series = await _nbpApi.fetchSeries(pair, start, end);
        await _sqlite.storeSeries(pair, series);
        return series;
      }
      final series = await _ecbApi.fetchSeries(pair);
      final filtered = series.where((point) => !point.timestamp.isBefore(start) && !point.timestamp.isAfter(end)).toList();
      await _sqlite.storeSeries(pair, filtered);
      return filtered;
    } catch (_) {
      final offline = await _sqlite.readSeries(pair);
      if (offline.isNotEmpty) {
        return offline;
      }
      rethrow;
    }
  }

  ChartStats computeStats(List<RatePoint> points) {
    if (points.isEmpty) {
      return ChartStats.empty;
    }
    final first = points.first.value;
    final last = points.last.value;
    final high = points.fold<double>(points.first.value, (prev, e) => max(prev, e.value));
    final low = points.fold<double>(points.first.value, (prev, e) => min(prev, e.value));
    final avg = points.map((e) => e.value).reduce((a, b) => a + b) / points.length;
    final delta = ((last - first) / first) * 100;
    return ChartStats(deltaPct: delta, high: high, low: low, avg: avg);
  }

  Future<bool> isOnline() async {
    final status = await Connectivity().checkConnectivity();
    return status != ConnectivityResult.none;
  }
}
