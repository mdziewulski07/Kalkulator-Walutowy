import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_walutowy/main.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await tester.pumpWidget(const App());
    // Poczekaj aż delegaty lokalizacji się załadują.
    await tester.pumpAndSettle();
    expect(find.byType(App), findsOneWidget);
  });
}
