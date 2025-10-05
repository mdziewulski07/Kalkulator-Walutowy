import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class EcbApi {
  EcbApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<RatePoint>> fetchSeries(CurrencyPair pair) async {
    final uri = Uri.parse('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.csv');
    final response = await _client.get(uri);
    if (response.statusCode >= 400) {
      throw Exception('ECB error: ${response.statusCode}');
    }
    final csv = const Utf8Decoder().convert(response.bodyBytes);
    final lines = LineSplitter.split(csv).toList();
    if (lines.isEmpty) return [];
    final headers = lines.first.split(',');
    final baseIndex = headers.indexOf(pair.base.toUpperCase());
    final quoteIndex = headers.indexOf(pair.quote.toUpperCase());
    if (baseIndex == -1 || quoteIndex == -1) {
      throw Exception('Currency not supported by ECB');
    }
    final points = <RatePoint>[];
    for (var i = 1; i < lines.length; i++) {
      final row = lines[i].split(',');
      if (row.length <= baseIndex || row.length <= quoteIndex) continue;
      final date = DateTime.tryParse(row[0]);
      final baseValue = double.tryParse(row[baseIndex]);
      final quoteValue = double.tryParse(row[quoteIndex]);
      if (date != null && baseValue != null && quoteValue != null) {
        final rate = quoteValue / baseValue;
        points.add(RatePoint(timestamp: date, value: rate));
      }
    }
    points.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return points;
  }
}
