import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/segmented_control.dart';

void main() {
  testWidgets('Segmented control changes selection', (tester) async {
    ChartRange? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: SegmentedControl<ChartRange>(
          options: const {
            ChartRange.d1: '1D',
            ChartRange.d3: '3D',
          },
          value: ChartRange.d1,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('3D'));
    expect(selected, ChartRange.d3);
  });
}

enum ChartRange { d1, d3 }
