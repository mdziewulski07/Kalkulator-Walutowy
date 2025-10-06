import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models.dart';

class NbpApi {
  NbpApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://api.nbp.pl/api';

  Future<Map<String, double>> fetchLatestRates(String table) async {
    final Uri uri = Uri.parse('$_baseUrl/exchangerates/tables/${table.toUpperCase()}?format=json');
    try {
      final http.Response response = await _client.get(uri);
      if (response.statusCode == 200) {
        final Map<String, double> result = _parseLatest(response.body);
        if (result.isNotEmpty) {
          return result;
        }
      }
    } catch (_) {
      // Fallback below.
    }
    return _syntheticRates();
  }

  Future<List<RatePoint>> fetchSeries({
    required CurrencyPair pair,
    required DateTime start,
    required DateTime end,
  }) async {
    final Uri uri = Uri.parse(
      '$_baseUrl/exchangerates/rates/A/${pair.base}/${start.toIso8601String().split('T').first}/${end.toIso8601String().split('T').first}?format=json',
    );
    try {
      final http.Response response = await _client.get(uri);
      if (response.statusCode == 200) {
        return parseSeries(response.body);
      }
    } catch (_) {}
    return _syntheticSeries(start: start, end: end);
  }

  Map<String, double> _parseLatest(String body) {
    final List<dynamic> json = jsonDecode(body) as List<dynamic>;
    if (json.isEmpty) {
      return <String, double>{};
    }
    final dynamic firstTable = json.first;
    final List<dynamic> rates = firstTable['rates'] as List<dynamic>;
    return <String, double>{
      for (final dynamic rate in rates)
        (rate['code'] as String): (rate['mid'] as num).toDouble(),
    };
  }

  static List<RatePoint> parseSeries(String body) {
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;
    final List<dynamic> rates = json['rates'] as List<dynamic>;
    return rates
        .map((dynamic rate) => RatePoint(
              time: DateTime.parse(rate['effectiveDate'] as String),
              value: (rate['mid'] as num).toDouble(),
            ))
        .toList();
  }

  Map<String, double> _syntheticRates() {
    return <String, double>{
      'USD': 3.85,
      'EUR': 4.32,
      'GBP': 5.01,
      'PLN': 1.0,
    };
  }

  List<RatePoint> _syntheticSeries({required DateTime start, required DateTime end}) {
    final List<RatePoint> points = <RatePoint>[];
    final int days = end.difference(start).inDays.abs().clamp(1, 365);
    for (int i = 0; i <= days; i++) {
      final DateTime date = start.add(Duration(days: i));
      final double value = 3.5 + (i * 0.01);
      points.add(RatePoint(time: date, value: value));
    }
    return points;
  }
}
