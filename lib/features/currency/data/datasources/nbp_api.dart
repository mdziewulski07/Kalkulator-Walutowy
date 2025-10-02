import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class NbpApiClient {
  NbpApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://api.nbp.pl/api';
  final http.Client _client;

  Future<double> fetchLatestRate(CurrencyPair pair) async {
    final response = await _retry(() {
      final endpoint = '$_baseUrl/exchangerates/rates/A/${pair.base.toLowerCase()}';
      return _client.get(Uri.parse('$endpoint?format=json'));
    });

    if (response.statusCode != 200) {
      throw Exception('NBP latest rate error ${response.statusCode}');
    }

    final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final rates = data['rates'] as List<dynamic>;
    if (rates.isEmpty) {
      throw Exception('NBP response empty');
    }

    final mid = (rates.first as Map<String, dynamic>)['mid'] as num;
    if (pair.quote.toUpperCase() == 'PLN') {
      return mid.toDouble();
    }

    // cross rate using PLN as intermediary
    final quoteResponse = await _retry(() {
      final endpoint = '$_baseUrl/exchangerates/rates/A/${pair.quote.toLowerCase()}';
      return _client.get(Uri.parse('$endpoint?format=json'));
    });

    if (quoteResponse.statusCode != 200) {
      throw Exception('NBP quote error ${quoteResponse.statusCode}');
    }
    final quoteData =
        json.decode(utf8.decode(quoteResponse.bodyBytes)) as Map<String, dynamic>;
    final quoteRates = quoteData['rates'] as List<dynamic>;
    if (quoteRates.isEmpty) {
      throw Exception('NBP quote response empty');
    }
    final quoteMid = (quoteRates.first as Map<String, dynamic>)['mid'] as num;
    return mid.toDouble() / quoteMid.toDouble();
  }

  Future<List<RatePoint>> fetchSeries({
    required CurrencyPair pair,
    required DateTime start,
    required DateTime end,
  }) async {
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);
    final uri = Uri.parse(
      '$_baseUrl/exchangerates/rates/A/${pair.base.toLowerCase()}/$startStr/$endStr/?format=json',
    );
    final response = await _retry(() => _client.get(uri));
    if (response.statusCode != 200) {
      throw Exception('NBP series error ${response.statusCode}');
    }
    final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final rates = (data['rates'] as List<dynamic>).cast<Map<String, dynamic>>();
    if (rates.isEmpty) {
      return [];
    }
    final values = rates.map((item) {
      final date = DateTime.parse(item['effectiveDate'] as String);
      final mid = (item['mid'] as num).toDouble();
      return RatePoint(time: date, value: mid);
    }).toList();

    if (pair.quote.toUpperCase() == 'PLN') {
      return values;
    }

    final quoteUri = Uri.parse(
      '$_baseUrl/exchangerates/rates/A/${pair.quote.toLowerCase()}/$startStr/$endStr/?format=json',
    );
    final quoteResponse = await _retry(() => _client.get(quoteUri));
    if (quoteResponse.statusCode != 200) {
      throw Exception('NBP quote series error ${quoteResponse.statusCode}');
    }
    final quoteData =
        json.decode(utf8.decode(quoteResponse.bodyBytes)) as Map<String, dynamic>;
    final quoteRates =
        (quoteData['rates'] as List<dynamic>).cast<Map<String, dynamic>>();
    final quoteMap = {
      for (final item in quoteRates)
        DateTime.parse(item['effectiveDate'] as String):
            (item['mid'] as num).toDouble(),
    };

    return values
        .where((point) => quoteMap.containsKey(point.time))
        .map((point) =>
            RatePoint(time: point.time, value: point.value / quoteMap[point.time]!))
        .toList();
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

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
