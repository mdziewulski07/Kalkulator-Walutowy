import 'dart:convert';

import 'package:dio/dio.dart';

import '../models.dart';

class NbpApi {
  NbpApi(this._client);

  final Dio _client;

  Future<double> fetchLatestRate(CurrencyPair pair) async {
    final table = pair.base == 'PLN' ? 'C' : 'A';
    final response = await _client.get<String>(
      'https://api.nbp.pl/api/exchangerates/rates/$table/${pair.base}/${pair.quote}?format=json',
      options: Options(responseType: ResponseType.plain),
    );
    final data = jsonDecode(response.data!) as Map<String, dynamic>;
    final rates = data['rates'] as List<dynamic>;
    final first = rates.first as Map<String, dynamic>;
    final value = (first['mid'] ?? first['ask']) as num;
    return value.toDouble();
  }

  Future<List<RatePoint>> fetchSeries(CurrencyPair pair, {required DateTime start}) async {
    final table = pair.base == 'PLN' ? 'C' : 'A';
    final response = await _client.get<String>(
      'https://api.nbp.pl/api/exchangerates/rates/$table/${pair.base}/${pair.quote}/${_formatDate(start)}/${_formatDate(DateTime.now())}?format=json',
      options: Options(responseType: ResponseType.plain),
    );
    final data = jsonDecode(response.data!) as Map<String, dynamic>;
    final rates = data['rates'] as List<dynamic>;
    return rates.map((raw) {
      final rate = raw as Map<String, dynamic>;
      final value = (rate['mid'] ?? rate['ask']) as num;
      return RatePoint(
        time: DateTime.parse(rate['effectiveDate'] as String),
        value: value.toDouble(),
      );
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
