import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_walutowy/features/currency/data/models.dart';

void main() {
  test('Repository scenario placeholder', () {
    const pair = CurrencyPair(base: 'USD', quote: 'PLN');
    expect(pair.base, 'USD');
  });
}
