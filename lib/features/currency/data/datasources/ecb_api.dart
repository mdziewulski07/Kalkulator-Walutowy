import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class EcbApiClient {
  EcbApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const _dailyUrl =
      'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.csv';
  final http.Client _client;

  Future<List<RatePoint>> fetchSeries({
    required CurrencyPair pair,
    required DateTime start,
    required DateTime end,
  }) async {
    final response = await _retry(() => _client.get(Uri.parse(_dailyUrl)));
    if (response.statusCode != 200) {
      throw Exception('ECB error ${response.statusCode}');
    }

    final csv = utf8.decode(response.bodyBytes);
    final lines = const LineSplitter().convert(csv);
    if (lines.length < 2) {
      return [];
    }
    final header = lines.first.split(',');
    final baseIndex = header.indexOf(pair.base.toUpperCase());
    final quoteIndex = header.indexOf(pair.quote.toUpperCase());

    final results = <RatePoint>[];
    for (final line in lines.skip(1)) {
      if (line.isEmpty) continue;
      final cells = line.split(',');
      if (cells.length < max(baseIndex, quoteIndex)) continue;
      final date = DateTime.tryParse(cells.first);
      if (date == null) continue;
      if (date.isBefore(start) || date.isAfter(end)) continue;

      final baseRate = baseIndex == -1
          ? 1.0
          : double.tryParse(cells[baseIndex]) ?? double.nan;
      final quoteRate = quoteIndex == -1
          ? 1.0
          : double.tryParse(cells[quoteIndex]) ?? double.nan;

      if (baseRate.isNaN || quoteRate.isNaN) continue;

      final value = _crossRate(baseRate, quoteRate);
      results.add(RatePoint(time: date, value: value));
    }
    return results..sort((a, b) => a.time.compareTo(b.time));
  }

  double _crossRate(double baseRate, double quoteRate) {
    // ECB provides EUR base; to compute base/quote we use: (EUR/quote) / (EUR/base)
    return quoteRate / baseRate;
  }

  Future<http.Response> _retry(Future<http.Response> Function() action) async {
    final attempts = 3;
    var delay = const Duration(milliseconds: 200);
    late http.Response response;
    for (var i = 0; i < attempts; i++) {
      try {
        response = await action();
        if (response.statusCode < 500) {
          return response;
        }
      } catch (_) {
        if (i == attempts - 1) rethrow;
      }
      await Future<void>.delayed(delay);
      delay = Duration(milliseconds: min(delay.inMilliseconds * 2, 1200));
    }
    return response;
  }
}
