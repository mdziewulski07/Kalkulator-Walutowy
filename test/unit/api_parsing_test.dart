import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse NBP sample', () async {
    final file = File('assets/fixtures/nbp_sample.json');
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final rate = json['rates'][0]['mid'];
    expect(rate, 3.95);
  });

  test('Parse ECB sample', () async {
    final file = File('assets/fixtures/ecb_sample.csv');
    final lines = await file.readAsLines();
    expect(lines.length, 4);
  });
}
