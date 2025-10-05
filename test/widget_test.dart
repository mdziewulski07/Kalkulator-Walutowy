import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/main.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await tester.pumpWidget(const App());
    // Minimalna asercja: aplikacja się renderuje.
    expect(find.byType(App), findsOneWidget);
  });
}
