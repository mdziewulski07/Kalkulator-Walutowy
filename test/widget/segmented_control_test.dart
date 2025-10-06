import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/segmented_control.dart';

void main() {
  testWidgets('Segmented control toggles selection', (WidgetTester tester) async {
    TestRange? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SegmentedControl<TestRange>(
            value: TestRange.d1,
            onChanged: (TestRange value) => selected = value,
            options: const <SegmentedOption<TestRange>>[
              SegmentedOption<TestRange>(value: TestRange.d1, label: '1D'),
              SegmentedOption<TestRange>(value: TestRange.m1, label: '1M'),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('1M'));
    await tester.pump();

    expect(selected, TestRange.m1);
  });
}

enum TestRange { d1, m1 }
