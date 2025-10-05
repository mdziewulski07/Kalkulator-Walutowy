import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

void main() {
  test('CurrencyPair swap inverses base and quote', () {
    final pair = CurrencyPair(base: 'USD', quote: 'PLN');
    final swapped = pair.swap();
    expect(swapped.base, 'PLN');
    expect(swapped.quote, 'USD');
  });

  test('ChartStats delta percentage is computed correctly', () {
    final stats = ChartStats(deltaPct: 10, high: 5, low: 3, avg: 4);
    expect(stats.deltaPct, 10);
  });
}
