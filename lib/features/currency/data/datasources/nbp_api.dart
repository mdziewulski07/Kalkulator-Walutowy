import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class NbpApi {
  NbpApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<double> fetchRate(CurrencyPair pair) async {
    final uri = Uri.parse('https://api.nbp.pl/api/exchangerates/rates/a/${pair.base.toLowerCase()}/?format=json');
    final response = await _client.get(uri, headers: {'accept': 'application/json'});
    if (response.statusCode >= 400) {
      throw Exception('NBP error: ${response.statusCode}');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final rates = json['rates'] as List<dynamic>;
    if (rates.isEmpty) {
      throw Exception('NBP empty response');
    }
    final rate = (rates.last as Map<String, dynamic>)['mid'] as num;
    if (pair.quote.toUpperCase() == 'PLN') {
      return rate.toDouble();
    }
    if (pair.base.toUpperCase() == 'PLN') {
      return 1 / rate;
    }
    throw Exception('NBP supports PLN pairs only');
  }

  Future<List<RatePoint>> fetchSeries(CurrencyPair pair, DateTime start, DateTime end) async {
    final uri = Uri.parse('https://api.nbp.pl/api/exchangerates/rates/a/${pair.base.toLowerCase()}/${_fmt(start)}/${_fmt(end)}/?format=json');
    final response = await _client.get(uri, headers: {'accept': 'application/json'});
    if (response.statusCode >= 400) {
      throw Exception('NBP error: ${response.statusCode}');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final rates = json['rates'] as List<dynamic>;
    return rates
        .map((dynamic item) {
          final map = item as Map<String, dynamic>;
          return RatePoint(
            timestamp: DateTime.parse('${map['effectiveDate']}T00:00:00Z').toLocal(),
            value: (map['mid'] as num).toDouble(),
          );
        })
        .toList();
  }

  String _fmt(DateTime date) => date.toIso8601String().substring(0, 10);
}
