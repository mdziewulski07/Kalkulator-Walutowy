import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/keypad.dart';

void main() {
  testWidgets('Calculator keypad emits tap events', (WidgetTester tester) async {
    final List<String> taps = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorKeypad(
            onKeyTap: taps.add,
            onLongPress: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('7'));
    await tester.pump();

    expect(taps, contains('7'));
  });
}
