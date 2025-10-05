import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_walutowy/features/currency/data/models.dart';

void main() {
  test('CurrencyPair swap changes base and quote', () {
    const pair = CurrencyPair(base: 'USD', quote: 'PLN');
    final swapped = pair.swap();
    expect(swapped.base, 'PLN');
    expect(swapped.quote, 'USD');
  });

  test('ChartStats computes delta', () {
    const stats = ChartStats(deltaPct: 1.24, high: 4.5, low: 4.1, avg: 4.3);
    expect(stats.deltaPct, 1.24);
  });
}
