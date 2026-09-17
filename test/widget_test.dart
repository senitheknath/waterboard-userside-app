import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const WaterUtilityApp());
    expect(find.text('Water Bill'), findsOneWidget);
  });
}
