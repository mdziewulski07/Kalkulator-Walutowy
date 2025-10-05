import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_walutowy/features/currency/presentation/widgets/keypad.dart';

void main() {
  testWidgets('Keypad taps emit values', (tester) async {
    final taps = <String>[];
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Keypad(onKeyPressed: taps.add))));

    await tester.tap(find.text('7'));
    await tester.pump();

    expect(taps, ['7']);
  });
}
