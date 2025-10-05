import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kalkulator_walutowy/features/currency/data/datasources/ecb_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class _FakeClient extends http.BaseClient {
  _FakeClient(this.body, {this.headers = const {}});
  final String body;
  final Map<String, String> headers;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = http.Response(body, 200, headers: headers);
    return http.StreamedResponse(Stream.fromIterable([response.bodyBytes]), 200, headers: headers);
  }
}

void main() {
  test('NBP API parsing', () async {
    final file = File('test/fixtures/nbp_response.json');
    final json = await file.readAsString();
    final client = _FakeClient(json, headers: {'content-type': 'application/json'});
    final api = NbpApi(client: client);
    final rate = await api.fetchRate(CurrencyPair(base: 'USD', quote: 'PLN'));
    expect(rate, greaterThan(0));
  });

  test('ECB CSV parsing', () async {
    final csv = await File('test/fixtures/ecb_response.csv').readAsString();
    final client = _FakeClient(csv);
    final api = EcbApi(client: client);
    final series = await api.fetchSeries(CurrencyPair(base: 'USD', quote: 'PLN'));
    expect(series, isNotEmpty);
  });
}
