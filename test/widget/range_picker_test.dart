import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/segmented_control.dart';

void main() {
  testWidgets('segmented control changes selection', (tester) async {
    ChartRange? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SegmentedControl<ChartRange>(
            items: const {
              ChartRange.d1: '1D',
              ChartRange.m1: '1M',
            },
            value: ChartRange.d1,
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('1M'));
    expect(selected, ChartRange.m1);
  });
}

enum ChartRange { d1, m1 }
