import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('NBP parsing', () {
    test('parses latest rate', () async {
      final client = _MockClient();
      final api = NbpApiClient(client: client);
      when(() => client.get(any())).thenAnswer((_) async => http.Response(
            File('test/fixtures/nbp_latest.json').readAsStringSync(),
            200,
          ));
      final rate = await api.fetchLatestRate(const CurrencyPair(base: 'USD', quote: 'PLN'));
      expect(rate, 3.63);
    });
  });
}
