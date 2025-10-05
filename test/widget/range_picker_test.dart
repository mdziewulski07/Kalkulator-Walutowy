import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_walutowy/features/currency/presentation/widgets/range_picker.dart';

void main() {
  testWidgets('Range picker selects index', (tester) async {
    int selectedIndex = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RangePicker(
          segments: const ['1D', '1W', '1M'],
          selected: selectedIndex,
          onSelected: (index) => selectedIndex = index,
        ),
      ),
    ));

    await tester.tap(find.text('1M'));
    await tester.pump();

    expect(selectedIndex, 2);
  });
}
