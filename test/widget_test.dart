import 'package:flutter_test/flutter_test.dart';
import 'package:personal_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads
    expect(find.byType(MyApp), findsOneWidget);
  });
}
