import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_walutowy/features/currency/application/calculator_cubit.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/models/models.dart';
import 'package:mocktail/mocktail.dart';

class _FakeRepository extends Fake implements CurrencyRepository {}

void main() {
  test('percentage applies correctly', () {
    final settings = Settings.initial().copyWith(decimals: 2);
    final cubit = CalculatorCubit(repository: _FakeRepository(), settings: settings);
    cubit.inputDigit('1');
    cubit.inputDigit('0');
    cubit.applyPercent();
    expect(cubit.state.inputBuffer, '0,10');
  });
}
