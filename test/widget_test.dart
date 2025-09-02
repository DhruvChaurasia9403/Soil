// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:readsoil/main.dart'; // TODO: Adjust path if your main.dart is elsewhere

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // FIXED: Changed MyApp() to ReadSoilApp()
    await tester.pumpWidget(ReadSoilApp());

    // You can add more specific tests here later. For now, this just verifies
    // that the app can be built by the test environment without errors.
    expect(find.byType(ReadSoilApp), findsOneWidget);
  });
}