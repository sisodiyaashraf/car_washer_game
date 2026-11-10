import 'package:flutter_test/flutter_test.dart';
import 'package:carwasher/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CarWasherApp());
    expect(find.text('CAR WASH & REPAIR'), findsOneWidget);
  });
}
