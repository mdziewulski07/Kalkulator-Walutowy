import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/widgets/keypad.dart';

void main() {
  testWidgets('keypad emits digits', (tester) async {
    var tapped = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorKeypad(
            onDigit: (value) => tapped = value,
            onOperator: (_) {},
            onDecimal: () {},
            onPercent: () {},
            onClear: () {},
            onBackspace: () {},
            onEquals: () {},
            onTip: () {},
            tipLabel: 'Tip',
          ),
        ),
      ),
    );

    await tester.tap(find.text('7'));
    expect(tapped, '7');
  });
}
